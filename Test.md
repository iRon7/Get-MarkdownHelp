# Test
Formats (aligns) a Csv table

## [Syntax](#syntax)
```Console
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
    [-Quote]
    [-Fenced]
    [<CommonParameters>]
```
## [Description](#description)
This cmdlet makes a Csv file or list better human readable by aligning the columns in a way that the resulted
Csv format is still a valid as input for the ConvertFrom-Csv cmdlet.

## [Examples](#examples)
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

## [Parameter](#parameter)
### `-InputObject`
Specifies the CSV strings to be formatted or the objects that are converted to CSV formatted strings.
You can also pipe objects to ConvertTo-CSV.

| Name:                       | InputObject |
| --------------------------- | ----- |
| Type:                       | [Object](https://docs.microsoft.com/en-us/dotnet/api/System.Object) |
| Position:                   | 0 |
| Default value:              |  |
| Accept pipeline input:      | False |
| Accept wildcard characters: | False |

### `-Delimiter`
Specifies the delimiter to separate the property values in CSV strings. The default is a comma (,).
Enter a character, such as a colon (:). To specify a semicolon (;) enclose it in single quotation marks.

List
1
2
3

| Name:                       | Delimiter |
| --------------------------- | ----- |
| Type:                       | [Char](https://docs.microsoft.com/en-us/dotnet/api/System.Char) |
| Position:                   | 1 |
| Default value:              | ',' |
| Accept pipeline input:      | False |
| Accept wildcard characters: | False |

### `-ValidateCount`

| Name:                       | ValidateCount |
| --------------------------- | ----- |
| Accepted length             | 1 - 2 |
| Type:                       | [Int32](https://docs.microsoft.com/en-us/dotnet/api/System.Int32) |
| Position:                   | 2 |
| Default value:              |  |
| Accept pipeline input:      | False |
| Accept wildcard characters: | False |

### `-ValidateLength`

| Name:                       | ValidateLength |
| --------------------------- | ----- |
| Accepted length             | 1 - 2 |
| Type:                       | [Int32](https://docs.microsoft.com/en-us/dotnet/api/System.Int32) |
| Position:                   | 3 |
| Default value:              |  |
| Accept pipeline input:      | False |
| Accept wildcard characters: | False |

### `-ValidatePattern`

| Name:                       | ValidatePattern |
| --------------------------- | ----- |
| Accepted pattern:           | `^[a-z]+$` |
| Type:                       | [String](https://docs.microsoft.com/en-us/dotnet/api/System.String) |
| Position:                   | 4 |
| Default value:              |  |
| Accept pipeline input:      | False |
| Accept wildcard characters: | False |

### `-ValidateRange`

| Name:                       | ValidateRange |
| --------------------------- | ----- |
| Accepted range:             | 1 - 9 |
| Type:                       | [Int32](https://docs.microsoft.com/en-us/dotnet/api/System.Int32) |
| Position:                   | 5 |
| Default value:              |  |
| Accept pipeline input:      | False |
| Accept wildcard characters: | False |

### `-ValidateScript`

| Name:                       | ValidateScript |
| --------------------------- | ----- |
| Accepted script condition:  | `$_ -eq 20` |
| Type:                       | [String](https://docs.microsoft.com/en-us/dotnet/api/System.String) |
| Position:                   | 6 |
| Default value:              |  |
| Accept pipeline input:      | False |
| Accept wildcard characters: | False |

### `-ValidateSet`
Specifies the alignment of the columns
* Left  - to align all the columns to the left
* Right - to align all the columns to the Right
* Auto  - to autmatically align each cell depending on the column and cell contents

When autmatic alignment is set, the whole column is aligned to the right if all cells are numeric. Besides,
each individual cell that contains a number type (e.g. integer) will also aligned to the right.

| Name:                       | ValidateSet |
| --------------------------- | ----- |
| Accepted values:            | Auto, Left, Right |
| Type:                       | [String](https://docs.microsoft.com/en-us/dotnet/api/System.String) |
| Position:                   | 7 |
| Default value:              | 'Auto' |
| Accept pipeline input:      | False |
| Accept wildcard characters: | False |

### `-SupportsWildcards`

| Name:                       | SupportsWildcards |
| --------------------------- | ----- |
| Type:                       | [String](https://docs.microsoft.com/en-us/dotnet/api/System.String) |
| Position:                   | 8 |
| Default value:              |  |
| Accept pipeline input:      | False |
| Accept wildcard characters: | True |

### `-Quote`
Quotes all the headers and values. If the Quote switch is set, all the delimeters are aligned.
(By default, each value is directly followed by a delimiter for compatibility reasons.)

| Name:                       | Quote |
| --------------------------- | ----- |
| Type:                       | [SwitchParameter](https://docs.microsoft.com/en-us/dotnet/api/System.Management.Automation.SwitchParameter) |
| Position:                   | Named |
| Default value:              |  |
| Accept pipeline input:      | False |
| Accept wildcard characters: | False |

### `-Fenced`
xxxx```
This shows some Fenced code:
```Console
Test () {
    Write-Host 'test'
}
```
Footnote

| Name:                       | Fenced |
| --------------------------- | ----- |
| Type:                       | [SwitchParameter](https://docs.microsoft.com/en-us/dotnet/api/System.Management.Automation.SwitchParameter) |
| Position:                   | Named |
| Default value:              |  |
| Accept pipeline input:      | False |
| Accept wildcard characters: | False |

## [Inputs](#Inputs)
Csv (here) string or object list

## [Outputs](#Outputs)
```PowerShell
    String[]
```

## [Related Links](#Related Links)
```PowerShell
    https://github.com/iRon7/Format-Csv
```
#>
