Readme ELDeviceObjectsViewer

2016.08.30

# Summary
　ELDeviceObjectsViewer は「ECHONET 機器オブジェクト詳細規定」をデータ化した JSON file を読み込み表示するiOS用のソフトウェアです。このプロジェクトにはJSON fileが含まれていますが、JSON fileは以下のサイトからdownloadできます。JSON fileの説明もこちらです。
　https://github.com/KAIT-HEMS/ECHONET-APPENDIX

- deviceObject_G.json: 機器オブジェクト（Super Classを除く）
- nodeProfile.json: Node Profile（Super Class + 機器オブジェクト)
- superClass.json: Super Class

# 使い方
　XCodeでビルドしてiOS device(iPhone/iPad)にインストールしてください。GUIはsimpleなので説明はいらないと思います。表示されるデータに関しては、こちらを参照してください。
　https://github.com/KAIT-HEMS/ECHONET-APPENDIX/blob/master/Readme_EL-JSON.md

# その他
　JSON parserとしては __Unbox__ を利用しています。project内の __JsonStruct.swift__ を見れば、JSON dataの詳細が理解できると思います。