require 'rack'
require_relative './src/prometheus/collector'
require_relative './src/prometheus/exporter'
require_relative './src/rack_dispatcher'

use Rack::Deflater, if: ->(_, _, _, body) { body.any? && body[0].length > 512 }
use Prometheus::Middleware::Collector
use Prometheus::Middleware::Exporter

$stdout.sync = true
$stderr.sync = true

run RackDispatcher.new