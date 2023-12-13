# font 埋め込み設定(WSL)
#	kanji-config-updmap ipaex
#
#
# vim: set tabstop=2 :
#***********************************************************************
# penguin_sty makefile
#
#***********************************************************************
#
# Tex 卒論/修論すたいるファイル
#
#***********************************************************************
#
#  ※ 研究室環境用に文字コードがEUC-JPなので注意！
#
#
#  make         論文データをコンパイル→main.pdf
#  make cover   学科提出用の表紙のみ作成→cover.pdf
#  make pdf		上記2つのpdfを作成→main.pdf cover.pdf
#  make clean   dviファイルを作るために生成したファイルを消去
#
#
#  必要に応じて，BODYの定義を書き換えてください
#
#***********************************************************************
#
#  DATE             DIARY
# =============   ======================================================
#  2011/02/14      作ってみた
#  2012/01/29      篠塚に使わせたら苦情が来た
#  2012/01/31      改築計画立案?”住罎鮨燭鹵罎豊?4年のスタイルもまとめる
#  2016/10/22      木内にbibtex関係が分かりにくいって文句言われた
#  2022/11/29      研究室環境updateに合わせて更新
#
#
#***********************************************************************

#骨格になるtexファイル 
#(.tex拡張子は書かないこと)
MAIN=main

#--[main.texが参照するtexファイル]-------------------

#追加した.texファイルがあれば，拡張子付で書き足す
BODY=1_intro.tex 2_background.tex 3_survey.tex 4_method.tex	5_method.tex 6_discuss.tex thanks.tex
#BODY=1_intro.tex 6_discuss.tex thanks.tex

APPEND=appendix.tex
COVER=cover

# bibファイルを追加するときはここに書き足す
# (.bibの拡張子は記述しないこと)
REF=bibfile

#--[コンパイルコマンド]------

#まえかわんが環境を変えちゃったとき用
PLATEX=platex
BIBTEX=pbibtex
DVIPDFM=dvipdfmx

#--[普通に使うならここから下は書き換え不要なはず]------

SRC 		= $(MAIN).tex $(BODY) $(APPEND)  $(REF).bib $(REF).tex 

ABSTDELFILE = ils.tfm 

DELFILE 	= $(MAIN).lof $(MAIN).lot $(MAIN).toc $(MAIN).log $(MAIN).aux $(MAIN).blg 

KOUGAITEX=kougai

#$(ABSTDELFILE)
#DELCOVER	= $(COVER).log $(COVER).aux
#------------------------------------------------------

all:COMPILE2
	$(DVIPDFM) $(MAIN)

COMPILE2:BIBCOMPILE
	$(PLATEX) $(MAIN)

BIBCOMPILE:$(REF).bib  $(REF).tex COMPILE
	-@ $(BIBTEX) $(MAIN)

COMPILE:makefile $(SRC) 
	$(PLATEX) $(MAIN)

#------------------------------------------------------

kougai:KOUGAI_COMPILE2
	$(DVIPDFM) $(KOUGAITEX)
	rm $(KOUGAITEX).log $(KOUGAITEX).aux $(KOUGAITEX).dvi $(KOUGAITEX).fls

  

KOUGAI_COMPILE2:KOUGAI_COMPILE
	$(PLATEX) $(KOUGAITEX)

KOUGAI_COMPILE:$(KOUGAITEX)
	$(PLATEX) $(KOUGAITEX)

cover: platex_cover
	$(DVIPDFM) $(COVER)
	rm $(COVER).log $(COVER).aux
	evince $(COVER).pdf &

platex_cover: $(COVER).tex abstract.tex
	$(PLATEX) $(COVER)

#------------------------------------------------------

pdf:all cover
	evince $(MAIN).pdf &
#	echo create "cover.pdf" & "main.pdf"

#------------------------------------------------------

.PHONY:clean

clean:$(DELFILE) $(DELCOVER)
	rm -f $^


