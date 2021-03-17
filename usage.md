# 本ソフトウェアの使い方

## ハードウェアの準備
   
   以下のサイトを参照してハードウェアを用意し、raspberry pi の ピンヘッダに接続する  
   https://nekokohouse.sakura.ne.jp/raspi/#rasp_rtc
   
   以降は、このハーウェアが接続されている raspberrypi 4B 上で ubuntu が動いてる状態でのソフトウェアの
   使い方を示す  
   raspberrypi os では試してないが、最後の注意事項を参考にすれば動くのではないかと思う（試してはいない）  

## ソフトウェアを使用可能状態にセットアップする

1. src/ ディレクトリに移動して、ドライバをビルドしてインストールする
```shell:bash
cd src
make
sudo make install
```

2. デバイスツリーファイルを作成して、インストールする
```shell:bash
./dtb_make.sh
sudo ./dtb_make.sh install
```

3. カーネルがアップデートした時、ドライバのビルド、インストールを行ってくれるように設定する  
まずは `build_pcf2127mod` をエディタで開き、git で取得したファイル一式が置いて合るファイルパスを `SRCTOP` に指定する（以下は例）
```shell:bash
# set full path of pcf2127mod
SRCTOP='/home/hogehoge/pcf2127mod'
```

4. アップデート用スクリプトをインストールする
```shell:bash
sudo ./install_apt.sh install
```
これはカーネルが apt によってアップデートした時にドライバの make, install を行うスクリプトであるが、十分な動作確認をしていないので、カーネルアップデート時には
正しくドライバがインストールされたかどうか確認すること  

5. ubuntu の場合 `/boot/firmware/usercfg.txt` を編集して、以下の2行を追加する（例）
```text:dts
dtoverlay=i2c6,pins_22_23,baudrate=400000
dtoverlay=i2c-rtc-pcf2127,pcf2129_11,i2c6,wakeup-source,init-regs,clear-ints
```
1行目の記述について、詳しくは以下を参照のこと  
https://github.com/raspberrypi/linux/blob/rpi-5.4.y/arch/arm/boot/dts/overlays/README

2行目の記述については、以下を参考にオプションを指定する
- 接続するデバイスの指定  
  pcf2129 の時 -> `pcf2129_11`  
  pcf2127 の時 -> `pcf2127_11`  
  pca2129 の時 -> `pca2129_11`  

- デバイスを接続する i2c バスの指定  
      i2c1 の時 -> `i2c1`  
      i2c3 の時 -> `i2c3`  
      i2c4 の時 -> `i2c4`  
      i2c5 の時 -> `i2c5`  
      i2c6 の時 -> `i2c6`  

- alarm 機能を使う時  
-> `wakeup-source`

- ドライバロード時にレジスタを初期化する時  
-> `init-regs`

- ドライバロード時に割り込みを初期化する時  
-> `clear-ints`

6. 再起動する。`/dev/rtc`, `/sys/class/rtc/rtc0`, `/proc/driver/rtc` などが作成され、rtc 関係のツールが動作することを確認する
```shell:bash
sudo hwclock -w   # システム時間を rtc に書き込む
sudo hwclock -r   # rtc 時間を読み込んで表示する
sudo rtcwake --date +3min -m off  # すぐにシャットダウンして、3分後に起動する
```

7. バッテリー状態やアラーム起動情報が取得できるか確認する
```shell:bash
cat /sys/class/rtc/rtc0/alarmwaked   # もし rtcwake を使ってアラーム起動したあとだったら 1 が表示される
cat /sys/class/rtc/rtc0/batterylow   # 電池がちゃんとはめてあれば 0 が表示される。電池切れだったら 1 が表示される
```

## 注意
raspberrypi os の場合はファームウェアのパス等、ubuntu とはいくつか違う点があるので以下の点に注意する

  - 2.でデバイスツリーファイルをインストールした後 `/boot/overlays/i2c-rtc-pcf2127.dtbo` が存在しない場合は
    手動でコピーする（正しくコピーされるようにしてあるはずだが要確認）

  - 5.で示される 2行を追加するファイルは `/boot/config.txt` になる。  

  - 詳しく調べていないが、raspberrypi os では `fake-hwclock` というサービスが動いていてこれが rtc の動作の妨げになるらしいので、
    web で情報を調べてこれを無効化する必要があるだろう（ubuntu はデフォルトでこのサービスは稼働してない）


以上
