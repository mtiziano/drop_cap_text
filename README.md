
[![pub package](https://img.shields.io/pub/v/drop_cap_text.svg)](https://pub.dartlang.org/packages/drop_cap_text)
[![Awesome](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)](https://stackoverflow.com/questions/tagged/flutter?sort=votes)


This Flutter plugin aims to achive [drop cap](https://en.wikipedia.org/wiki/Initial#Types_of_initial) in text capitalization.

## Usage

To use this plugin, add `drop_cap_text` as a dependency in your pubspec.yaml file.
```yaml
dependencies:
  drop_cap_text: ^1.0.2
```

```dart
import 'package:drop_cap_text/drop_cap_text.dart';
```

```dart
DropCapText(
    loremIpsumText,
    style: TextStyle(fontStyle: FontStyle.italic),
),
```

![ex1](https://i.ibb.co/wQMn1z3/ex1.png)

### Properties

| Name            | Type               | Default                 | Description        |
| --------------- | ------------------ | ----------------------- | ------------------ |
| data            | String             | null                    |                    |
| mode            | DropCapMode        | DropCapMode.inside      | aside, upwards, .. |
| textAlign       | TextAlign          | null                    |                    |
| indentation     | Offset             | Offset.zero             |                    |
| dropCapChars    | int                | 1                       |                    |
| dropCapPadding  | EdgeInsets         | EdgeInsets.zero         |                    |
| dropCap         | DropCap `[Widget]` | null                    |                    |
| style           | TextStyle          | null                    |                    |
| dropCapStyle    | TextStyle          |                         |                    |
| forceNoDescent  | bool               | false                   |                    |
| dropCapPosition | DropCapPosition    | DropCapPosition.start   |                    |
| textDirection   | TextDirection      | TextDirection.ltr       |                    |



## Customization

##### Custom DropCap Widget: Image

![ex3](https://i.ibb.co/D43w1H8/ex3.png)

```dart
DropCapText(
    loremIpsumText,
    dropCap: DropCap(
    width: 100,
    height: 100,
    child: Image.network(
    	'https://www.codemate.com/wp-content/uploads/2017/09/flutter-logo.png')
    ),
),
```


##### Custom DropCap Widget: Image right + justification

![ex7](https://i.ibb.co/WVPT3HH/img-end.jpg)

```dart
DropCapText(
    loremIpsumText,
    dropCapPosition: DropCapPosition.end,
    textAlign: TextAlign.justify,
    dropCap: DropCap(
    width: 100,
    height: 100,
    child: Image.network(
    	'https://www.codemate.com/wp-content/uploads/2017/09/flutter-logo.png')
    ),
),
```

------

##### 2 characters + indentation 

![ex2](https://i.ibb.co/yq1Vj7q/ex2.png)

```dart
DropCapText(
    loremIpsumText,
    style: TextStyle(
        height: 1.3,
        fontFamily: 'times',
    ),
    dropCapChars: 2,
    indentation: Offset(25, 10),
),
```

------

##### Upward drop cap 

![ex5](https://i.ibb.co/b3M6KD8/ex5.png)

```dart
DropCapText(
    loremIpsumText,
    mode: DropCapMode.upwards,
    dropCapStyle: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
        fontSize: 120,
        fontFamily: 'times',
    ),
),
```

------

##### Aside drop cap

![ex6](https://i.ibb.co/bFmrM6G/ex6.png)

```dart
DropCapText(
    loremIpsumText,
    style: TextStyle(
        fontWeight: FontWeight.bold,
        height: 1.2,
    ),
    mode: DropCapMode.aside,
),
```

