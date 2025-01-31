//= require d3/dist/d3
//= require cal-heatmap/dist/cal-heatmap
//= require popper
//= require cal-heatmap/dist/plugins/Tooltip


/* global CalHeatmap, Tooltip */
document.addEventListener("DOMContentLoaded", () => {
  const heatmapElement = document.querySelector("#cal-heatmap");

  if (!heatmapElement) {
    console.warn("Heatmap element not found in the DOM.");
    return;
  }

  const heatmapData = heatmapElement.dataset.heatmap ? JSON.parse(heatmapElement.dataset.heatmap) : [];
  const colorScheme = heatmapElement.dataset.siteColorScheme || "auto";
  const locale = I18n.locale;
  const rangeColors = ["#14432a", "#166b34", "#37a446", "#4dd05a"];
  const startDate = new Date(Date.now() - (365 * 24 * 60 * 60 * 1000));

  const theme = getThemeFromColorScheme(colorScheme);
  const mediaQuery = window.matchMedia("(prefers-color-scheme: dark)");

  let cal = new CalHeatmap();
  renderHeatmap(theme);

  if (colorScheme === "auto") {
    mediaQuery.addEventListener("change", (e) => {
      const newTheme = e.matches ? "dark" : "light";
      renderHeatmap(newTheme);
    });
  }

  function renderHeatmap(currentTheme) {
    cal.destroy();
    cal = new CalHeatmap();
    cal.paint({
      itemSelector: "#cal-heatmap",
      theme: currentTheme,
      domain: {
        type: "month",
        gutter: 4,
        label: {
          text: (timestamp) => getMonthNameFromTranslations(locale, new Date(timestamp).getMonth()),
          position: "top",
          textAlign: "middle"
        },
        dynamicDimension: true
      },
      subDomain: {
        type: "ghDay",
        radius: 2,
        width: 11,
        height: 11,
        gutter: 4
      },
      date: {
        start: startDate
      },
      range: 13,
      data: {
        source: heatmapData,
        type: "json",
        x: "date",
        y: "total_changes"
      },
      scale: {
        color: {
          type: "threshold",
          range: currentTheme === "dark" ? rangeColors : Array.from(rangeColors).reverse(),
          domain: [10, 20, 30, 40]
        }
      }
    }, [
      [Tooltip, {
        text: (date, value) => getTooltipText(date, value, locale)
      }]
    ]);
  }
});

function getThemeFromColorScheme(colorScheme) {
  if (colorScheme === "auto") {
    return window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
  }
  return colorScheme;
}

function getMonthNameFromTranslations(locale, monthIndex) {
  const translations = I18n.translations[locale] || I18n.translations.en;
  const date = translations && translations.date;
  const abbrMonthNames = date && date.abbr_month_names;

  const months = abbrMonthNames || [];
  return months[monthIndex + 1] || "";
}

function getTooltipText(date, value) {
  const localizedDate = I18n.l("date.formats.long", date);
  return value > 0 ?
    I18n.t("javascripts.heatmap.tooltip.contributions", { count: value, date: localizedDate }) :
    I18n.t("javascripts.heatmap.tooltip.no_contributions", { date: localizedDate });
}
