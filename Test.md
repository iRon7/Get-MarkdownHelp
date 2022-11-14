# Test.ps1
Formats (aligns) a Csv table

## [Syntax](#syntax)
```JavaScript
Test.ps1
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
Csv format is still a valid as input for the [`ConvertFrom-Csv`](https://go.microsoft.com/fwlink/?LinkID=2096830) cmdlet.

## [Examples](#examples)
### Example 1: Named Example

Five,       5, More,     Normal

### Example 2:
Another example

## [Parameter](#parameter)
### `-InputObject <Object>`
You can also pipe objects to [`ConvertTo-CSV`](https://go.microsoft.com/fwlink/?LinkID=2096832).


<table>
<tr><td>Type:</td><td>[Object](https://docs.microsoft.com/en-us/dotnet/api/System.Object)</td></tr>
<tr><td>Position:</td><td>0</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

### `-Delimiter <Char>`

3


<table>
<tr><td>Type:</td><td>[Char](https://docs.microsoft.com/en-us/dotnet/api/System.Char)</td></tr>
<tr><td>Position:</td><td>1</td></tr>
<tr><td>Default value:</td><td>','</td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

### `-ValidateCount <Int32>`


<table>
<tr><td>Accepted length:</td><td>-1</td></tr>
<tr><td>Type:</td><td>[Int32](https://docs.microsoft.com/en-us/dotnet/api/System.Int32)</td></tr>
<tr><td>Position:</td><td>2</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

### `-ValidateLength <Int32>`


<table>
<tr><td>Accepted length:</td><td>-1</td></tr>
<tr><td>Type:</td><td>[Int32](https://docs.microsoft.com/en-us/dotnet/api/System.Int32)</td></tr>
<tr><td>Position:</td><td>3</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

### `-ValidatePattern <String>`


<table>
<tr><td>Accepted pattern:</td><td>`^[a-z]+$`</td></tr>
<tr><td>Type:</td><td>[String](https://docs.microsoft.com/en-us/dotnet/api/System.String)</td></tr>
<tr><td>Position:</td><td>4</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

### `-ValidateRange <Int32>`


<table>
<tr><td>Accepted range:</td><td>-8</td></tr>
<tr><td>Type:</td><td>[Int32](https://docs.microsoft.com/en-us/dotnet/api/System.Int32)</td></tr>
<tr><td>Position:</td><td>5</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

### `-ValidateScript <String>`


<table>
<tr><td>Accepted script condition:</td><td>`$_ -eq 20`</td></tr>
<tr><td>Type:</td><td>[String](https://docs.microsoft.com/en-us/dotnet/api/System.String)</td></tr>
<tr><td>Position:</td><td>6</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

### `-ValidateSet <String>`

each individual cell that contains a number type (e.g. [integer][2]) will also aligned to the right.


<table>
<tr><td>Accepted values:</td><td>Auto, Left, Right</td></tr>
<tr><td>Type:</td><td>[String](https://docs.microsoft.com/en-us/dotnet/api/System.String)</td></tr>
<tr><td>Position:</td><td>7</td></tr>
<tr><td>Default value:</td><td>'Auto'</td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

### `-SupportsWildcards <String>`


<table>
<tr><td>Type:</td><td>[String](https://docs.microsoft.com/en-us/dotnet/api/System.String)</td></tr>
<tr><td>Position:</td><td>8</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>True</td></tr>
</table>

### `-Quote`
(By default, each value is directly followed by a delimiter for compatibility reasons.)


<table>
<tr><td>Type:</td><td>[SwitchParameter](https://docs.microsoft.com/en-us/dotnet/api/System.Management.Automation.SwitchParameter)</td></tr>
<tr><td>Position:</td><td>Named</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

### `-Code <String>`


Footnote


<table>
<tr><td>Type:</td><td>[String](https://docs.microsoft.com/en-us/dotnet/api/System.String)</td></tr>
<tr><td>Position:</td><td>9</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

### `-Fenced <String>`
This shows some Fenced code:

```Console
Test () {
Write-Host 'test'
}
```
Footnote


<table>
<tr><td>Type:</td><td>[String](https://docs.microsoft.com/en-us/dotnet/api/System.String)</td></tr>
<tr><td>Position:</td><td>10</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

### `-PSCode <String>`
}


<table>
<tr><td>Type:</td><td>[String](https://docs.microsoft.com/en-us/dotnet/api/System.String)</td></tr>
<tr><td>Position:</td><td>11</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

## [Inputs](#Inputs)
Csv (here) string or object list

## [Outputs](#Outputs)
String[]

## [Related Links](#RelatedLinks)
* https://github.com/iRon7/Format-Csv
* [Test](https://en.wikipedia.org/wiki/Integer)
* 1: https://www.linguee.nl/engels-nederlands/vertaling/automatic+alignment.html
* [2]: https://en.wikipedia.org/wiki/Integer (Integer)

[1]: https://www.linguee.nl/engels-nederlands/vertaling/automatic+alignment.html
