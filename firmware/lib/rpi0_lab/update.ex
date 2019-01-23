defmodule Rpi0Lab.Update do
  @moduledoc """
  Documentation for Rpi0Lab.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Rpi0Lab.hello
      :world

  """
  require Logger
  @number Application.get_env(:rpi0_lab, :number)
  def network_config(_args) do
    key_mgmt = System.get_env("NERVES_NETWORK_KEY_MGMT") || "WPA-PSK"

    ok_deleter = fn {:ok, res} -> res  end

    def_ifconfig =
      [
        wlan0: [
        networks: [
          [
            ssid: "Jabba The Hub",
            psk: "stardust",
            priority: 10,
            key_mgmt: String.to_atom(key_mgmt)
          ],
          [
            ssid: "lnk1b1",
            ipv4_address_method: :static,
            ipv4_address: "172.28.27.132",
            ipv4_subnet_mask: "255.255.255.0",
            ipv4_gateway: "172.28.27.254",
            nameservers: ["144.1.6.242", "144.1.6.243"],
            priority: 100,
            key_mgmt: :NONE,
            wep_key0: :"36f21849b9",
            wep_tx_keyidx: 0
          ],
          # [
          #   ssid: :inet.gethostname() |> ok_deleter.() |> List.to_string(),
          #   psk: :inet.gethostname() |> ok_deleter.() |> List.to_string(),
          #   priority: 0,
          #   key_mgmt: String.to_atom(key_mgmt)
          # ],
        ]
      ],
      usb0: [
        ipv4_address_method: :linklocal
      ]
    ]

    Application.put_env(:nerves_network, :default, def_ifconfig)
  end

  def looper(n) do
    Process.sleep(1000)
    Logger.info("#{@number}")
    n=n+1
    looper(n)
  end
end
