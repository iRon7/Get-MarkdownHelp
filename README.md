# Test
Formats (aligns) a Csv table
## [Syntax](#syntax)
```JavaScript
Test
    [-InputObject] <Object>
    [[-Delimiter] <char>]
    [[-ValidateCount] <int>]
    [[-ValidateLength] <int>]
    [[-ValidatePattern] <string>]
    [[-ValidateRange] <int>]
    [[-ValidateScript] <string>]
    [[-ValidateSet] <string>]
    [[-SupportsWildcards] <string>]
    [[-Code] <string>]
    [[-Fenced] <string>]
    [[-PSCode] <string>]
    [-Quote]
    [<CommonParameters>]
```
## [Description](#description)
This cmdlet makes a Csv file or list better human readable by aligning the columns in a way that the resulted
Csv format is still a valid as input for the ConvertFrom-Csv cmdlet.
## [Examples](#examples)
### Example 1: Named Example
```PowerShell
$Csv = @'
"Name","Number","Object","Remark"
"One","1","Text","Normal"
"Two","2","123","Number"
"Three","3","Te,xt","Comma in Text"
"Four","4","Te""xt","Double quote in text"
,,,"Empty ($Null)"
"Five","5","More","Normal"
'@

$Csv |Format-Csv
Name,  Number, Object,   Remark
One,        1, Text,     Normal
Two,        2, 123,      Number
Three,      3, "Te,xt",  "Comma in Text"
Four,       4, "Te""xt", "Double quote in text"
,            , ,         "Empty ($Null)"
Five,       5, More,     Normal
```
### Example 2:
Another example
## [Parameter](#parameter)
### `-InputObject <Object>`
Specifies the CSV strings to be formatted or the objects that are converted to CSV formatted strings.
You can also pipe objects to ConvertTo-CSV.

| Name:                       | InputObject |
| :-------------------------- | :---- |
| Type:                       | [Object](https://docs.microsoft.com/en-us/dotnet/api/System.Object) |
| Position:                   | 0 |
| Default value:              |  |
| Accept pipeline input:      | False |
| Accept wildcard characters: | False |

### `-Delimiter <Char>`
Specifies the delimiter to separate the property values in CSV strings. The default is a comma (,).
Enter a character, such as a colon (:). To specify a semicolon (;) enclose it in single quotation marks.

List
1
2
3

| Name:                       | Delimiter |
| :-------------------------- | :---- |
| Type:                       | [Char](https://docs.microsoft.com/en-us/dotnet/api/System.Char) |
| Position:                   | 1 |
| Default value:              | ',' |
| Accept pipeline input:      | False |
| Accept wildcard characters: | False |

### `-ValidateCount <Int32>`


| Name:                       | ValidateCount |
| :-------------------------- | :---- |
| Accepted length             | 1 - 2 |
| Type:                       | [Int32](https://docs.microsoft.com/en-us/dotnet/api/System.Int32) |
| Position:                   | 2 |
| Default value:              |  |
| Accept pipeline input:      | False |
| Accept wildcard characters: | False |

### `-ValidateLength <Int32>`


| Name:                       | ValidateLength |
| :-------------------------- | :---- |
| Accepted length             | 1 - 2 |
| Type:                       | [Int32](https://docs.microsoft.com/en-us/dotnet/api/System.Int32) |
| Position:                   | 3 |
| Default value:              |  |
| Accept pipeline input:      | False |
| Accept wildcard characters: | False |

### `-ValidatePattern <String>`


| Name:                       | ValidatePattern |
| :-------------------------- | :---- |
| Accepted pattern:           | `^[a-z]+$` |
| Type:                       | [String](https://docs.microsoft.com/en-us/dotnet/api/System.String) |
| Position:                   | 4 |
| Default value:              |  |
| Accept pipeline input:      | False |
| Accept wildcard characters: | False |

### `-ValidateRange <Int32>`


| Name:                       | ValidateRange |
| :-------------------------- | :---- |
| Accepted range:             | 1 - 9 |
| Type:                       | [Int32](https://docs.microsoft.com/en-us/dotnet/api/System.Int32) |
| Position:                   | 5 |
| Default value:              |  |
| Accept pipeline input:      | False |
| Accept wildcard characters: | False |

### `-ValidateScript <String>`


| Name:                       | ValidateScript |
| :-------------------------- | :---- |
| Accepted script condition:  | `$_ -eq 20` |
| Type:                       | [String](https://docs.microsoft.com/en-us/dotnet/api/System.String) |
| Position:                   | 6 |
| Default value:              |  |
| Accept pipeline input:      | False |
| Accept wildcard characters: | False |

### `-ValidateSet <String>`
Specifies the alignment of the columns
* Left  - to align all the columns to the left
* Right - to align all the columns to the Right
* Auto  - to autmatically align each cell depending on the column and cell contents

When [automatic alignment][1] is set, the whole column is aligned to the right if all cells are numeric. Besides,
each individual cell that contains a number type (e.g. [integer][2]) will also aligned to the right.

| Name:                       | ValidateSet |
| :-------------------------- | :---- |
| Accepted values:            | Auto, Left, Right |
| Type:                       | [String](https://docs.microsoft.com/en-us/dotnet/api/System.String) |
| Position:                   | 7 |
| Default value:              | 'Auto' |
| Accept pipeline input:      | False |
| Accept wildcard characters: | False |

### `-SupportsWildcards <String>`


| Name:                       | SupportsWildcards |
| :-------------------------- | :---- |
| Type:                       | [String](https://docs.microsoft.com/en-us/dotnet/api/System.String) |
| Position:                   | 8 |
| Default value:              |  |
| Accept pipeline input:      | False |
| Accept wildcard characters: | True |

### `-Quote`
Quotes all the headers and values. If the Quote switch is set, all the delimeters are aligned.  
(By default, each value is directly followed by a delimiter for compatibility reasons.)

| Name:                       | Quote |
| :-------------------------- | :---- |
| Type:                       | [SwitchParameter](https://docs.microsoft.com/en-us/dotnet/api/System.Management.Automation.SwitchParameter) |
| Position:                   | Named |
| Default value:              |  |
| Accept pipeline input:      | False |
| Accept wildcard characters: | False |

### `-Code <String>`
This shows some Fenced code:
```PowerShell
Test () {
    Write-Host 'test'
}
```
Footnote

| Name:                       | Code |
| :-------------------------- | :---- |
| Type:                       | [String](https://docs.microsoft.com/en-us/dotnet/api/System.String) |
| Position:                   | 9 |
| Default value:              |  |
| Accept pipeline input:      | False |
| Accept wildcard characters: | False |

### `-Fenced <String>`
This shows some Fenced code:
```Console
Test () {
    Write-Host 'test'
}
```
Footnote

| Name:                       | Fenced |
| :-------------------------- | :---- |
| Type:                       | [String](https://docs.microsoft.com/en-us/dotnet/api/System.String) |
| Position:                   | 10 |
| Default value:              |  |
| Accept pipeline input:      | False |
| Accept wildcard characters: | False |

### `-PSCode <String>`
This shows some PS > prefixed code:
```PowerShell
Test2 () {
    Write-Host 'test'
}
```

| Name:                       | PSCode |
| :-------------------------- | :---- |
| Type:                       | [String](https://docs.microsoft.com/en-us/dotnet/api/System.String) |
| Position:                   | 11 |
| Default value:              |  |
| Accept pipeline input:      | False |
| Accept wildcard characters: | False |

## [Inputs](#Inputs)
Csv (here) string or object list
## [Outputs](#Outputs)
```PowerShell
String[]
```
## [Related Links](#RelatedLinks)
* https://github.com/iRon7/Format-Csv
* [Test](https://en.wikipedia.org/wiki/Integer)
* 1: https://www.linguee.nl/engels-nederlands/vertaling/automatic+alignment.html
* 2: [Integer][2]

[1]: https://www.linguee.nl/engels-nederlands/vertaling/automatic+alignment.html
[2]: https://en.wikipedia.org/wiki/Integer (Integer)
