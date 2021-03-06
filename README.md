# PCF2127 driver with alarm function for kernel 5.4

### 概要
linux kernel 5.11 に含まれる pcf2127 用ドライバを kernel 5.4 向けに変更したもの  
また、以下に示す目的のためにいくつかの機能を追加している

### 目的
raspberrypi 4B と Ubuntu Server 20.04.2 LTS 64bit 環境で作成しており、この環境下に於いて
rtc である pcf2129 のアラーム割り込みを使って PI の GPIO3 を制御し、halt 状態から起動させることを目的としている

### 改変元ソースコード
ドライバモジュールのソースコードは以下のもの  
> <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/rtc/rtc-pcf2127.c?h=v5.11-rc5>

オーバーレイのソースコードは以下のもの  
> <https://github.com/raspberrypi/linux/blob/rpi-5.4.y/arch/arm/boot/dts/overlays/i2c-rtc-overlay.dts>

### 主な変更点
* kernel 5.4 で利用できるように一部関数コールを変更。このため rmmod ができない
* アラーム時刻を読んだときのバグを修正（例えば `/proc/driver/rtc` を読んだ時のアラーム時刻が正しく表示される）
* 予めシステムにインストールされているドライバと衝突しないように、ファイル名、モジュール名、識別子などを変更
* モジュールがロードされたときの割り込みフラグ及びイネーブルを見て、アラーム起動したかどうかを判断する機能を追加
* 上記機能をファイルシステム経由でユーザーに提供する
* バッテリー切れ情報をファイルシステム経由でユーザーに提供する
* レジスタを初期化する機能を追加
* 改変したドライバ用に dts ファイルを変更。プロパティにより機能の有効無効を切り替えることができる。また、接続する i2c バスを指定できる

### ハードウェア情報
本ドライバの運用に於いて当方が想定しているハードウェアの情報は以下のサイトを参照のこと

> <https://nekokohouse.sakura.ne.jp/raspi/#rasp_rtc>

### 主な注意事項
カーネルがアップデートしたら、再度ビルドとインストールを行う必要がある。スクリプトによって自動的にビルド、インストールが行われるように
設定はしているが、デバッグが不十分なので、正しくインストールされたか確認したほうが良い。
`dmesg` や `lsmod` などを使ってドライバが動作していることを確認するのが良い

### 免責事項
本ソフトウェアの動作は保証しない。著作権者は一切の責任を負わない

### ソフトウェア・ライセンス
GPL v2 に従う。詳しくは LICENSE を参照のこと

### 改変者
Yachiyo https://nekokohouse.sakura.ne.jp
