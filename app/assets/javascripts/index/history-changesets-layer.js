OSM.HistoryChangesetsLayer = L.FeatureGroup.extend({
  _changesets: [],

  updateChangesets: function (map, changesets) {
    this._changesets = changesets;
    this.updateChangesetShapes(map);
  },

  updateChangesetShapes: function (map) {
    this.clearLayers();

    for (const changeset of this._changesets) {
      const bottomLeft = map.project(L.latLng(changeset.bbox.minlat, changeset.bbox.minlon)),
            topRight = map.project(L.latLng(changeset.bbox.maxlat, changeset.bbox.maxlon)),
            width = topRight.x - bottomLeft.x,
            height = bottomLeft.y - topRight.y,
            minSize = 20; // Min width/height of changeset in pixels

      if (width < minSize) {
        bottomLeft.x -= ((minSize - width) / 2);
        topRight.x += ((minSize - width) / 2);
      }

      if (height < minSize) {
        bottomLeft.y += ((minSize - height) / 2);
        topRight.y -= ((minSize - height) / 2);
      }

      changeset.bounds = L.latLngBounds(map.unproject(bottomLeft),
                                        map.unproject(topRight));
    }

    this._changesets.sort(function (a, b) {
      return b.bounds.getSize() - a.bounds.getSize();
    });

    this.updateChangesetLocations(map);

    for (const changeset of this._changesets) {
      const rect = L.rectangle(changeset.bounds,
                               { weight: 2, color: "#FF9500", opacity: 1, fillColor: "#FFFFAF", fillOpacity: 0 });
      rect.id = changeset.id;
      rect.addTo(this);
    }
  },

  updateChangesetLocations: function (map) {
    const mapCenterLng = map.getCenter().lng;

    for (const changeset of this._changesets) {
      const changesetSouthWest = changeset.bounds.getSouthWest();
      const changesetNorthEast = changeset.bounds.getNorthEast();
      const changesetCenterLng = (changesetSouthWest.lng + changesetNorthEast.lng) / 2;
      const shiftInWorldCircumferences = Math.round((changesetCenterLng - mapCenterLng) / 360);

      if (shiftInWorldCircumferences) {
        changesetSouthWest.lng -= shiftInWorldCircumferences * 360;
        changesetNorthEast.lng -= shiftInWorldCircumferences * 360;

        this.getLayer(changeset.id)?.setBounds(changeset.bounds);
      }
    }
  },

  highlightChangeset: function (id) {
    this.getLayer(id)?.setStyle({ fillOpacity: 0.3, color: "#FF6600", weight: 3 });
  },

  unHighlightChangeset: function (id) {
    this.getLayer(id)?.setStyle({ fillOpacity: 0, color: "#FF9500", weight: 2 });
  },

  getLayerId: function (layer) {
    return layer.id;
  }
});
