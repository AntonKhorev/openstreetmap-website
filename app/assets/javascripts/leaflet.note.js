L.OSM.note = function (options) {
  var control = L.control(options);

  control.onAdd = function (map) {
    var $container = $("<div>")
      .attr("class", "control-note");

    var link = $("<a>")
      .attr("class", "control-button")
      .attr("href", "#")
      .html("<span class=\"icon note\"></span>")
      .data("minZoom", 12)
      .appendTo($container);

    map.on("zoomend", update);

    function update() {
      var disabled = OSM.STATUS === "database_offline" || map.getZoom() < link.data("minZoom");
      link
        .toggleClass("disabled", disabled)
        .attr("data-bs-original-title", I18n.t(disabled ?
          "javascripts.site.createnote_disabled_tooltip" :
          "javascripts.site.createnote_tooltip"));
    }

    update();

    return $container[0];
  };

  return control;
};
