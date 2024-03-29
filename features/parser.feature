# language: ja

フィーチャ: narabi の文字列を解析する
  開発者として、
  シーケンス図をみるために、
  文字列からインスタンスとメッセージを取得したい。

  シナリオアウトライン: 一行の解析に成功
    前提 一行の文字列<入力値>を入力する
    もし 一行の文字列を解析する
    ならば 送信元は<送信元>となること
    かつ 受信先は<受信先>となること
    かつ 電文は<電文>となること

    例:
      | 入力値                   | 送信元   | 受信先   | 電文            |
      | "Foo->Bar: Some message" | "Foo"    | "Bar"    | "Some message"  |
      | "Bar-->Foo: Response"    | "Bar"    | "Foo"    | "Response"      |
      | " A 1 -> B 1 : M1 "      | " A 1 "  |  " B 1 " | "M1 "           |
      | "太郎->花子:"            | "太郎"   | "花子"   | ""              |
      | "太郎->花子:   "         | "太郎"   | "花子"   | "  "            |

  シナリオアウトライン: ノートの解析に成功
    前提 一行の文字列<入力値>を入力する
    もし 一行の文字列を解析する
    ならば 送信元は<送信元>となること
    かつ 受信先は<受信先>となること
    かつ 電文は<電文>となること

    例:
      | 入力値                       | 送信元 | 受信先 | 電文              |
      | "note User: This is a note." | "User" | "User" | "This is a note." |
      | "note User:"                 | "User" | "User" | ""                |
      | "note F 1: http://..."       | "F 1"  | "F 1"  | "http://..."      |
      | "note 日本: 語のノート"      | "日本" | "日本" | "語のノート"      |


  シナリオアウトライン: 呼び出しと応答
    前提 一行の文字列<入力値>を入力する
    もし 一行の文字列を解析する
    ならば 種類は<種類>となること

    例:
      | 入力値                   | 種類     |
      | "Foo->Bar: Some message" | 呼び出し |
      | "Bar-->Foo: Response"    | 応答     |
      | "note Foo: note"         | ノート   |

  シナリオアウトライン: 不正な行を解析
    前提 一行の文字列<入力値>を入力する
    もし 一行の文字列を解析する
    ならば メッセージは不正

    例:
      | 入力値      |
      | "Foo->Bar"  |
      | "Foo-->Bar" |
      | ""          |

  シナリオアウトライン: インスタンスの解析に成功
    前提 一行の文字列<入力値>を入力する
    もし 一行のインスタンス文字列を解析する
    ならば インスタンスは<名称>となること

    例:
      | 入力値          | 名称   |
      | "instance User" | "User" |
      | "instance "     | " "    |
      | "instance  "    | " "    |
      | "instance   "   | "  "   |

  シナリオアウトライン: タイトルの解析に成功
    前提 一行の文字列<入力値>を入力する
    もし 一行のタイトル文字列を解析する
    ならば タイトルは<タイトル>となること

    例:
      | 入力値              | タイトル      |
      | "title title #1"    | "title #1"    |
      | "title タイトル #1" | "タイトル #1" |

  シナリオ: エイリアスの解析に成功
    前提 次のエイリアスを含むテキストを入力する:
      """
      title w/ instance alias

      instance User as U
      instance System

      note U: This is a note.
      U->System: Login request
      System-->User: Response
      """
    もし エイリアスを含むテキストを解析する
    ならば 次のハッシュの配列となる:
      """
      {:title=>"w/ instance alias"}
      {:name=>"User",   :alias=>"U"}
      {:name=>"System"}
      {:from=>"User",   :to=>"User",    :body=>"This is a note.", :is_note=>true}
      {:from=>"User",   :to=>"System",  :body=>"Login request"}
      {:from=>"System", :to=>"User",    :body=>"Response",        :is_return=>true}
      """
