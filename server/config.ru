require_relative './src/prometheus/collector'
require_relative './src/prometheus/exporter'
require_relative './src/rack_dispatcher'
require_relative './src/external'
require 'rack'

use Rack::Deflater, if: ->(_, _, _, body) { body.any? && body[0].length > 512 }
use Prometheus::Middleware::Collector
use Prometheus::Middleware::Exporter

$stdout.sync = true
$stderr.sync = true

external = External.new
run RackDispatcher.new(external.storer)