OSM.DirectionsRouteOutput = function (map) {
  const popup = L.popup({ autoPanPadding: [100, 100] });

  const polyline = L.polyline([], {
    color: "#03f",
    opacity: 0.3,
    weight: 10
  });

  const highlight = L.polyline([], {
    color: "#ff0",
    opacity: 0.5,
    weight: 12
  });

  let distanceUnits = "km";
  let downloadURL = null;

  const miSize = 1609.344;
  const ftSize = 0.3048;

  function formatTotalDistance(m) {
    const scope = "javascripts.directions.distance_in_units";

    if (distanceUnits === "km") {
      const km = m / 1000;
      if (m < 1000) {
        return OSM.i18n.t("m", { scope, distance: Math.round(m) });
      } else if (km < 10) {
        return OSM.i18n.t("km", { scope, distance: km.toFixed(1) });
      } else {
        return OSM.i18n.t("km", { scope, distance: Math.round(km) });
      }
    } else {
      const ft = m / ftSize;
      const mi = m / miSize;
      if (ft < 1000) {
        return OSM.i18n.t("ft", { scope, distance: Math.round(ft) });
      } else if (mi < 10) {
        return OSM.i18n.t("mi", { scope, distance: mi.toFixed(1) });
      } else {
        return OSM.i18n.t("mi", { scope, distance: Math.round(mi) });
      }
    }
  }

  function formatStepDistance(m) {
    const scope = "javascripts.directions.distance_in_units";

    if (m < 5) {
      return "";
    } else if (distanceUnits === "km") {
      const km = m / 1000;
      if (m < 200) {
        return OSM.i18n.t("m", { scope, distance: Math.round(m / 10) * 10 });
      } else if (m < 1500) {
        return OSM.i18n.t("m", { scope, distance: Math.round(m / 100) * 100 });
      } else if (km < 5) {
        return OSM.i18n.t("km", { scope, distance: km.toFixed(1) });
      } else {
        return OSM.i18n.t("km", { scope, distance: Math.round(km) });
      }
    } else {
      const ft = m / ftSize;
      const mi = m / miSize;
      if (ft < 200) {
        return OSM.i18n.t("ft", { scope, distance: Math.round(ft / 10) * 10 });
      } else if (ft < 1500) {
        return OSM.i18n.t("ft", { scope, distance: Math.round(ft / 100) * 100 });
      } else if (mi < 5) {
        return OSM.i18n.t("mi", { scope, distance: mi.toFixed(1) });
      } else {
        return OSM.i18n.t("mi", { scope, distance: Math.round(mi) });
      }
    }
  }

  function formatHeight(m) {
    const scope = "javascripts.directions.distance_in_units";

    if (distanceUnits === "km") {
      return OSM.i18n.t("m", { scope, distance: Math.round(m) });
    } else {
      const ft = m / ftSize;
      return OSM.i18n.t("ft", { scope, distance: Math.round(ft) });
    }
  }

  function formatTime(s) {
    let m = Math.round(s / 60);
    const h = Math.floor(m / 60);
    m -= h * 60;
    return h + ":" + (m < 10 ? "0" : "") + m;
  }

  function writeSummary(route) {
    $("#directions_route_distance").val(formatTotalDistance(route.distance));
    $("#directions_route_time").val(formatTime(route.time));
    if (typeof route.ascend !== "undefined" && typeof route.descend !== "undefined") {
      $("#directions_route_ascend_descend").prop("hidden", false);
      $("#directions_route_ascend").val(formatHeight(route.ascend));
      $("#directions_route_descend").val(formatHeight(route.descend));
    } else {
      $("#directions_route_ascend_descend").prop("hidden", true);
      $("#directions_route_ascend").val("");
      $("#directions_route_descend").val("");
    }
  }

  function writeSteps(route) {
    $("#directions_route_steps").empty();

    for (const [i, [direction, instruction, dist, lineseg]] of route.steps.entries()) {
      const row = $("<tr class='turn'/>").appendTo($("#directions_route_steps"));

      if (direction) {
        row.append("<td class='border-0'><svg width='20' height='20' class='d-block'><use href='#routing-sprite-" + direction + "' /></svg></td>");
      } else {
        row.append("<td class='border-0'>");
      }
      row.append(`<td><b>${i + 1}.</b> ${instruction}`);
      row.append("<td class='distance text-body-secondary text-end'>" + formatStepDistance(dist));

      row.on("click", function () {
        popup
          .setLatLng(lineseg[0])
          .setContent(`<p><b>${i + 1}.</b> ${instruction}</p>`)
          .openOn(map);
      });

      row
        .on("mouseenter", function () {
          highlight
            .setLatLngs(lineseg)
            .addTo(map);
        })
        .on("mouseleave", function () {
          map.removeLayer(highlight);
        });
    }
  }

  const routeOutput = {};

  routeOutput.write = function (route) {
    polyline
      .setLatLngs(route.line)
      .addTo(map);

    writeSummary(route);
    writeSteps(route);

    $("#directions_distance_units_km").off().on("change", () => {
      distanceUnits = "km";
      writeSummary(route);
      writeSteps(route);
    });
    $("#directions_distance_units_mi").off().on("change", () => {
      distanceUnits = "mi";
      writeSummary(route);
      writeSteps(route);
    });

    const blob = new Blob([JSON.stringify(polyline.toGeoJSON())], { type: "application/json" });
    URL.revokeObjectURL(downloadURL);
    downloadURL = URL.createObjectURL(blob);
    $("#directions_route_download").prop("href", downloadURL);

    $("#directions_route_credit")
      .text(route.credit)
      .prop("href", route.creditlink);
  };

  routeOutput.fit = function () {
    map.fitBounds(polyline.getBounds().pad(0.05));
  };

  routeOutput.isVisible = function () {
    return map.hasLayer(polyline);
  };

  routeOutput.remove = function () {
    map
      .removeLayer(popup)
      .removeLayer(polyline);

    $("#directions_distance_units_km").off();
    $("#directions_distance_units_mi").off();

    $("#directions_route_steps").empty();

    URL.revokeObjectURL(downloadURL);
    $("#directions_route_download").prop("href", "");
  };

  return routeOutput;
};
