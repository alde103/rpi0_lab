# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"
config :nerves, :firmware, fwup_conf: "config/rpi0_can/fwup.conf"

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.

config :shoehorn,
  #init: [:nerves_runtime, :nerves_init_gadget],
  init: [:nerves_runtime, :nerves_init_gadget],
  app: Mix.Project.config()[:app]

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger,
  utc_log: true,
  handle_otp_reports: true,
  handle_sasl_reports: true,
  level: :debug,
  backends: [:console, RingLogger]

  config :logger, RingLogger, max_size: 1024

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

config :nerves_firmware_ssh,
  authorized_keys: [
    File.read!(Path.join(System.user_home!, ".ssh/id_rsa.pub"))
  ]

config :nerves_init_gadget,
  ifname: "usb0",
  address_method: :linklocal,
  node_name: "nerves_iot",
  mdns_domain: System.get_env("NODE_NAME") || "nerves.local"

key_mgmt = System.get_env("NERVES_NETWORK_KEY_MGMT") || "WPA-PSK"

config :nerves_network, :default,
  wlan0: [
    networks: [
      [
        ssid: System.get_env("SSID") || "Secret",
        psk: System.get_env("SSID_PSK") || "secretxx",
        key_mgmt: String.to_atom(key_mgmt)
      ]
    ]
  ],
  eth0: [
    ipv4_address_method: :static,
    ipv4_address: "192.168.0.100", ipv4_subnet_mask: "255.255.255.0",
    domain: "mycompany.com", nameservers: ["8.8.8.8", "8.8.4.4"]
  ],
  usb0: [
    ipv4_address_method: :linklocal
  ]

# config :nerves_init_gadget,
#   ifname: "wlan0",
#   address_method: :dhcp,
#   node_name: "nerves_iot",
#   mdns_domain: System.get_env("NODE_NAME") || "nerves.local"

config :nerves_neopixel,
  canvas: {10, 2},
  channels: [:channel1, :channel2],
  channel1: [
    pin: 18, #LIGHTPIPE
    type: :grbw,
    arrangement: [
      %{
        type: :strip,
        origin: {0, 0},
        count: 10,
        direction: :right
      }
    ]
  ],
  channel2: [
    pin: 13,
    type: :grbw,
    arrangement: [
      %{
        type: :strip,
        origin: {0, 1},
        count: 10,
        direction: :right
      }
    ]
  ]

# import_config "#{Mix.Project.config[:target]}.exs"
