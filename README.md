# swiftyTableView

tableViewのdatasourceをうまく作りたい
※実験段階

## コンセプト

- dataSourceについて、覚えづらいボイラープレートなコードを排除したい
- リアクティブだけどRxじゃない（ライブラリに依存せずとも使える）
- section一つで使うことが多いが、sectionを複数使いたいこともある（どっちでもスムーズに書ける）

## 使い方

#### セットアップ

```swift
let dataSource = TableViewDataSource<SampleTableViewCell, String>()
```

ViewControllerクラス内にでもインスタンスを持たせます。

- 一つ目のクラスはセルのクラス（今回はSampleTableViewCell）
- 二つ目のクラスは各セルに対応する値を保持するクラス（今回はString）

です。

```swift
dataSource.setup(cellIdentifier: "cell") { cell, data, indexPath in
    cell.textLabel?.text = data
}.bindTo(tableView: tableView)
```

`setup()` は必ず呼ぶ必要があります。

- 一つ目の引数は、tableViewからdequeするためのcell Identifier、
- 二つ目の引数は、cell, data, indexPathを受け取って、cellをセットアップするクロージャ

です。もちろん、data, cellは上で指定したクラスになっています。

```swift
.bindTo(tableView: tableView)
```

を呼び出すことで、 `tableView.dataSource` が自動的にセットされるだけでなく、以降のdataSourceの更新に対して、自動的に適切なreloadを行います。

但し、storyboardで登録する場合が多いと思いましたので、 `tableView.register` は実行しておりません。クラスを登録する場合は、

```swift
tableView.register(SampleTableViewCell.self, forCellReuseIdentifier: "cell")
```

のようなコードが必要になります。

#### データの更新

sectionが一つの場合は、sectionは自動的に0になります。

セル単位の操作

```swift
dataSource.append("に")
dataSource.append("に", section: 0)
dataSource.insert("は", row: 2)
dataSource.insert("は", row: 2, section: 0)
```

セクション単位の操作

```
dataSource.setItems(["い", "ろ"])
dataSource.setItems(["い", "ろ"], section: 0)
dataSource.delete(section: 0)
dataSource.append(SectionData(title: "kk", items: ["ねこ", "いぬ", "くじら"]))
```

ここで、 `SectionData` は1セクションに対応するデータです。

## 詳細な設定

#### cellIdentifier
indexPathによってセルが違う場合に用います。
`setup()` の引数としてcellIdentifierを指定する際に、 `(indexPath) -> (String)` として指定することもできます。
その際は、cellやデータのクラスは基底クラスにしておいて、セルのセットアップ時にキャストすることで実現できます。

#### アニメーション
現状はautomaticのみの対応です

