# splash

Splash is an open-source TI-83+ Zelda-like RPG game
coded in Assembly Z80 by Eric Nantel @ericnantel

<img src="./resources/images/title/title_color_186_54.png">

# Getting Started
- Open a Terminal
- GNU/Linux - Ubuntu is recommended
    - Install the following packages (mandatory)
    ```shell
        sudo apt install wine python
    ```
    - Install the following packages (optional)
    ```shell
        sudo apt install tilem tilp2
    ```
- Windows
    - Install the following packages (mandatory)
    ```shell
        scoop install python
    ```
    - Download Wabbitemu from web browser (recommended)
- MacOS
    - Install the following packages (mandatory)
    ```shell
        brew install wine python
    ```
    - Use Cemetech Jstify Online Emulator (recommended)
- Download ti83plus.inc (TASM version) from ticalc.org
- Download TASM Assembler (Windows 32bits Application) from ticalc.org
    - TASM.EXE (mandatory)
    - TASM80.TAB (mandatory for Z80)
- Download BinPac8x from Cemetech website (recommended)
    - binpac8x.py
- Download Devpac8x (DOS Application - NOT recommended)
    - DEVPAC8X.COM (For Windows 98; or DOSBox)
- Clone this repo
```shell
    mkdir ~/projects
    git clone https://github.com/ericnantel/splash ~/projects/splash
```
- Copy ti83plus.inc, TASM, BinPac8x to the project folder
```shell
    cp ~/Downloads/ti83plus.inc ~/projects/splash/ti83plus.inc
    mkdir -p ~/projects/splash/tasm
    cp ~/Downloads/TASM.EXE ~/projects/splash/tasm/TASM.EXE
    cp ~/Downloads/TASM80.TAB ~/projects/splash/tasm/TASM80.TAB
    mkdir -p ~/projects/splash/binpac8x
    cp ~/Downloads/BinPac8x/binpac8x.py ~/projects/splash/binpac8x/binpac8x.py
```
- Backup TI-83+ ROM from your own calculator (ideally version 1.19) to use emulators
    - On Ubuntu, you can use tilp2 to legally retrieve it locally.
    ```shell
        mkdir -p ~/projects/splash/roms/ti83p_v1_19
        ~/projects/splash/roms/ti83p_v1_19/ti83plus.rom
    ```
- Build game
```shell
    sh BUILD.sh
```
- Test with emulators (requires ROM) or Upload the game to your calculator (requires tilp2 and a Silver Link Cable)
```shell
    ~/projects/splash/binaries/splash.8xp
```

# Support
- Subscribe to my Youtube Channel [Youtube Link](https://youtube.com/c/EricNantel)
- Give this repo a :star: (thank you)

