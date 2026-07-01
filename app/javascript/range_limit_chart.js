import { Chart } from "chart.js"

// Local customization of the blacklight_range_limit distribution chart.
// The gem intentionally leaves `drawChart` overridable (see its comment), so we
// replace it to match the DataWorks design: fog-light background, light-blue
// bars with white separators, visible axis tick dashes, y-axis numbers on every
// other tick (plus the top), and no gridlines. The bar fill comes from the
// range_config data attribute set in catalog_controller.
//
// Note: upstream plots density (count / bucket width) and hides the y-axis
// because that number isn't meaningful. We plot the raw document COUNT as the
// bar height so the visible y-axis numbers represent document counts.

const BAR_COLOR_FALLBACK = "#6FC3FF"
const SEPARATOR_COLOR = "#fff"
const TICK_COLOR = "#888"
const TICK_LENGTH = 6
const DEFAULT_ASPECT_RATIO = 2
const CHART_PADDING = { top: 20, right: 12, left: 10, bottom: 0 }

// Thousands separators for the y-axis counts ("10,000")
const Y_TICK_FORMAT = new Intl.NumberFormat("en-US")

// Shared axis grid: no gridlines or axis line, just tick dashes.
const AXIS_TICK_GRID = {
  drawOnChartArea: false,
  drawTicks: true,
  tickLength: TICK_LENGTH,
  tickColor: TICK_COLOR
}

// Two stepped-line points per bucket (flat top), using count as the height.
function stepPoints(buckets) {
  return buckets.flatMap((b) => [
    { x: b.from, y: b.count },
    { x: b.to + 1, y: b.count }
  ])
}

// A white separator at each bucket boundary, sized to the taller of the two
// adjacent bars so the line only covers bar area, not the empty background.
function boundarySeparators(buckets) {
  const separators = buckets.map((b, i) => {
    const prev = buckets[i - 1]
    return { x: b.from, h: prev ? Math.max(prev.count, b.count) : b.count }
  })
  const last = buckets[buckets.length - 1]
  separators.push({ x: last.to + 1, h: last.count })
  return separators
}

function separatorsPlugin(separators) {
  return {
    id: "blrlSeparators",
    afterDatasetsDraw(chart) {
      const { ctx, chartArea, scales } = chart
      ctx.save()
      ctx.strokeStyle = SEPARATOR_COLOR
      ctx.lineWidth = 1
      separators.forEach(({ x, h }) => {
        if (h <= 0) return
        const px = scales.x.getPixelForValue(x)
        ctx.beginPath()
        ctx.moveTo(px, chartArea.bottom)
        ctx.lineTo(px, scales.y.getPixelForValue(h))
        ctx.stroke()
      })
      ctx.restore()
    }
  }
}

export function customizeRangeLimitChart(BlacklightRangeLimit) {
  BlacklightRangeLimit.prototype.drawChart = function (chartCanvasElement) {
    const buckets = this.rangeBuckets
    if (!buckets || buckets.length === 0) return

    const points = stepPoints(buckets)
    const minX = points[0].x
    const maxX = points[points.length - 1].x
    const xTicks = this.xTicks

    const wrapper = chartCanvasElement.closest("*[data-chart-wrapper=true]")
    const aspectRatio =
      parseFloat(window.getComputedStyle(wrapper)?.getPropertyValue("aspect-ratio")) ||
      DEFAULT_ASPECT_RATIO

    const barColor =
      this.container.getAttribute("data-chart-segment-bg-color") || BAR_COLOR_FALLBACK

    new Chart(chartCanvasElement.getContext("2d"), {
      type: "line",
      plugins: [separatorsPlugin(boundarySeparators(buckets))],
      options: {
        animation: false,
        aspectRatio: aspectRatio,
        resizeDelay: 15,
        // Inset the chart from the fog panel edges; the bottom is left flush.
        layout: { padding: { ...CHART_PADDING } },
        plugins: {
          legend: false,
          tooltip: { enabled: false }
        },
        elements: { point: { radius: 0 } },
        scales: {
          x: {
            min: minX,
            max: maxX,
            type: "linear",
            grid: { ...AXIS_TICK_GRID },
            border: { display: false },
            afterBuildTicks: (axis) => {
              axis.ticks = xTicks.map((v) => ({ value: v }))
            },
            ticks: {
              autoSkip: true,
              maxRotation: 0,
              maxTicksLimit: 6,
              // Raw years, no locale grouping (avoids "2,020").
              callback: (val) => val
            }
          },
          y: {
            beginAtZero: true,
            grid: { ...AXIS_TICK_GRID },
            border: { display: false },
            ticks: {
              display: true,
              precision: 0,
              maxTicksLimit: 8,
              // A number on every other tick. Exception: with only two ticks,
              // label both so the top tick isn't left blank.
              callback: (value, index, ticks) =>
                ticks.length === 2 || index % 2 === 0 ? Y_TICK_FORMAT.format(value) : ""
            }
          }
        }
      },
      data: {
        datasets: [
          {
            data: points,
            stepped: true,
            fill: true,
            borderWidth: 0,
            backgroundColor: barColor
          }
        ]
      }
    })
  }
}
