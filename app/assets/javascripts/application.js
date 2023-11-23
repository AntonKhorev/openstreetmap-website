//= require jquery3
//= require jquery_ujs
//= require jquery.timers
//= require jquery.throttle-debounce
//= require js-cookie/dist/js.cookie
//= require popper
//= require bootstrap-sprockets
//= require osm
//= require leaflet/dist/leaflet-src
//= require leaflet.osm
//= require leaflet.map
//= require leaflet.zoom
//= require leaflet.locationfilter
//= require i18n
//= require oauth
//= require matomo
//= require richtext
//= require qs/dist/qs
//= require bs-custom-file-input
//= require bs-custom-file-input-init

/*
 * Called as the user scrolls/zooms around to manipulate hrefs of the
 * view tab and various other links
 */
window.updateLinks = function (loc, zoom, layers, object) {
  $(".geolink").each(function (index, link) {
    var href = link.href.split(/[?#]/)[0],
        args = Qs.parse(link.search.substring(1)),
        editlink = $(link).hasClass("editlink");

    delete args.node;
    delete args.way;
    delete args.relation;
    delete args.changeset;
    delete args.note;

    if (object && editlink) {
      args[object.type] = object.id;
    }

    var query = Qs.stringify(args);
    if (query) href += "?" + query;

    args = {
      lat: loc.lat,
      lon: "lon" in loc ? loc.lon : loc.lng,
      zoom: zoom
    };

    if (layers && !editlink) {
      args.layers = layers;
    }

    href += OSM.formatHash(args);

    link.href = href;
  });

  // Disable the button group and also the buttons to avoid
  // inconsistent behaviour when zooming
  var editDisabled = zoom < 13;
  $("#edit_tab")
    .tooltip({ placement: "bottom" })
    .tooltip(editDisabled ? "enable" : "disable")
    .toggleClass("disabled", editDisabled)
    .find("a")
    .toggleClass("disabled", editDisabled);
};

$(document).ready(function () {
  function updateHeader() {
    var inSmallNavMode = $(window).width() < 768;

    if (inSmallNavMode) {
      if (!$("body").hasClass("small-nav")) {
        $("body").addClass("small-nav");
        expandSecondaryMenu(
          $("#compact-secondary-nav > ul").find("li")
        );
      }
    } else {
      if ($("body").hasClass("small-nav")) {
        collapseSecondaryMenu(
          $("header nav.secondary > ul").find("li:not(#compact-secondary-nav)")
        );
        $("body").removeClass("small-nav");
      }
    }
    $("header nav.secondary").toggleClass("text-end", !inSmallNavMode);
  }

  function expandSecondaryMenu($items) {
    $items
      .addClass("nav-item")
      .children("a")
        .removeClass("dropdown-item")
        .addClass("nav-link")
      .end()
      .prependTo("header nav.secondary > ul");
    toggleCompactSecondaryNav();
  }

  function collapseSecondaryMenu($items) {
    $items
      .removeClass("nav-item")
      .children("a")
        .addClass("dropdown-item")
        .removeClass("nav-link")
      .end()
      .appendTo("#compact-secondary-nav > ul");
    toggleCompactSecondaryNav();
  }

  function toggleCompactSecondaryNav() {
    $("#compact-secondary-nav").toggle(
      $("#compact-secondary-nav > ul li").length > 0
    );
  }

  updateHeader();
  $(window).resize(updateHeader);

  $("#menu-icon").on("click", function (e) {
    e.preventDefault();
    $("header").toggleClass("closed");
  });

  $("nav.primary li a").on("click", function () {
    $("header").toggleClass("closed");
  });

  var application_data = $("head").data();

  I18n.default_locale = OSM.DEFAULT_LOCALE;
  I18n.locale = application_data.locale;
  I18n.fallbacks = true;

  OSM.preferred_editor = application_data.preferredEditor;
  OSM.preferred_languages = application_data.preferredLanguages;

  if (application_data.user) {
    OSM.user = application_data.user;

    if (application_data.userHome) {
      OSM.home = application_data.userHome;
    }
  }

  if (application_data.location) {
    OSM.location = application_data.location;
  }

  $("#edit_tab")
    .attr("title", I18n.t("javascripts.site.edit_disabled_tooltip"));
});
