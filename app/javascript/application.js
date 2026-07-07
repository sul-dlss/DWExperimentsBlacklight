// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import bootstrap from "bootstrap"
import githubAutoCompleteElement from "@github/auto-complete-element"
import Blacklight from 'blacklight-frontend'

import BlacklightRangeLimit from "blacklight-range-limit";
import { customizeRangeLimitChart } from "range_limit_chart";
customizeRangeLimitChart(BlacklightRangeLimit);
// Blacklight.onLoad fires on every turbo:load AND turbo:frame-load, so a turbo
// frame elsewhere on the page loading (e.g. the sidebar facet search box) would
// otherwise re-init range limit on the already-charted container and stack up
// duplicate graphs. Mark each container once initialized and skip it thereafter.
BlacklightRangeLimit.init({
  onLoadHandler: Blacklight.onLoad,
  callback: (instance) => {
    instance.container.setAttribute("data-range-limit-initialized", "true");
  },
  containerQuerySelector: ".limit_content.range_limit:not([data-range-limit-initialized])"
});
