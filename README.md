# HTB Academy Docker + OpenVPN Setup

I made this script with the help of ChatGPT to make setting up the tools faster and more portable. A lot of the time, we don't want to install tons of packages on our main distro, and relying on virtual machines can slow down the process or not even work on low-spec PCs — that's why I chose Docker.

## Objective

Automate the process of connecting to the VPN, starting the Docker container, and opening Firefox in kiosk mode for a smoother HTB Academy experience.

## Tools

The script use a Docker image from [linuxserver.io](https://linuxserver.io) that contains [Kali Linux](https://docs.linuxserver.io/images/docker-kali-linux/). Note that it is not a full virtual machine but a [Docker](https://www.docker.com/) container.

## Prerequisites

Before getting started, make sure you have installed:

- **Docker** and **Docker Compose**
- **Curl**
- **OpenVPN**
- **Firefox**

## Recommended Directory Structure

```
/home/user/htb/
    ├── /storage
    ├── pen.yaml
    ├── config.ovpn
    └── lab.sh
    └── vpn_downloader.sh
```

## How to Use the Script

### Full Startup

Clone the repository

```bash 
git clone --depth 1 https://github.com/Ersindacalista/Fast-HTB-Lab ~/htb
cd htb
```

Copy your HTB or any .ovpn file inside the folder, and make sure to name it config.ovpn

### First-Time Setup

For first-time setup (if you don’t have an OpenVPN file yet), run:

```bash
sudo ./lab.sh -init
```

This command will:

2. Ask for your Hack The Box credentials (API Key)
3. Download the `config.ovpn` file for you

### How to Get the API Key

1. Go to [Hack The Box Profile Settings](https://app.hackthebox.com/profile/settings)
2. Press the **Create App Token** button
3. Copy the generated token

To start everything up:

```bash
sudo ./lab.sh
```

The script will automatically:

1. Check for and stop any existing Docker containers
2. Start the VPN using the `config.ovpn` file
3. Verify that the VPN connection is active
4. Launch the Docker container
5. Open Firefox in kiosk mode with the default link `http://localhost:3000`

### Stop Services

To stop everything:

```bash
sudo lab.sh -stop
```

This command:

- Stops the Docker container
- Kills the OpenVPN process

## Troubleshooting

- **VPN won’t connect:** Ensure the `config.ovpn` file is valid and works manually (`sudo openvpn config.ovpn`).

## Future Improvements

In future versions, I plan to switch from the linuxserver.io Docker image to a custom Docker container built by me.

## Credits

Special thanks to the developers of the linuxserver.io Docker image for providing a solid base to work from: [linuxserver.io](https://linuxserver.io)

