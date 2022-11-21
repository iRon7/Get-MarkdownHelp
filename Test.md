# Test.ps1
Formats (aligns) a Csv table

## Syntax
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

## Description
This cmdlet makes a Csv file or list better human readable by aligning the columns in a way that the resulted
Csv format is still a valid as input for the [`ConvertFrom-Csv`](https://go.microsoft.com/fwlink/?LinkID=2096830) cmdlet.
See also: [-Quote](-Quote).

## Examples
### Example 1: Named Example
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
### Example 2:
Another example

## Parameter
<h4 id="-inputobject">**`-InputObject <Object>`**</h4><br/>
Specifies the CSV strings to be formatted or the objects that are converted to CSV formatted strings.
You can also pipe objects to [`ConvertTo-CSV`](https://go.microsoft.com/fwlink/?LinkID=2096832).


<table>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.Object">Object</a></td></tr>
<tr><td>Position:</td><td>0</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

<h4 id="-delimiter">**`-Delimiter <Char>`**</h4><br/>

Specifies the delimiter to separate the property values in CSV strings. The default is a comma (,).
Enter a character, such as a colon (:). To specify a semicolon (;) enclose it in single quotation marks.
List
1
2
3


<table>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.Char">Char</a></td></tr>
<tr><td>Position:</td><td>1</td></tr>
<tr><td>Default value:</td><td>','</td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

<h4 id="-validatecount">**`-ValidateCount <Int32>`**</h4><br/>


<table>
<tr><td>Accepted length:</td><td>-1</td></tr>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.Int32">Int32</a></td></tr>
<tr><td>Position:</td><td>2</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

<h4 id="-validatelength">**`-ValidateLength <Int32>`**</h4><br/>


<table>
<tr><td>Accepted length:</td><td>-1</td></tr>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.Int32">Int32</a></td></tr>
<tr><td>Position:</td><td>3</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

<h4 id="-validatepattern">**`-ValidatePattern <String>`**</h4><br/>


<table>
<tr><td>Accepted pattern:</td><td><code>^[a-z]+$</code></td></tr>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.String">String</a></td></tr>
<tr><td>Position:</td><td>4</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

<h4 id="-validaterange">**`-ValidateRange <Int32>`**</h4><br/>


<table>
<tr><td>Accepted range:</td><td>-8</td></tr>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.Int32">Int32</a></td></tr>
<tr><td>Position:</td><td>5</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

<h4 id="-validatescript">**`-ValidateScript <String>`**</h4><br/>


<table>
<tr><td>Accepted script condition:</td><td><code>$_ -eq 20</code></td></tr>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.String">String</a></td></tr>
<tr><td>Position:</td><td>6</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

<h4 id="-validateset">**`-ValidateSet <String>`**</h4><br/>

Specifies the alignment of the columns
* Left  - to align all the columns to the left
* Right - to align all the columns to the Right
* Auto  - to autmatically align each cell depending on the column and cell contents
When [automatic alignment][1] is set, the whole column is aligned to the right if all cells are numeric. Besides,
each individual cell that contains a number type (e.g. [integer][2]) will also aligned to the right.


<table>
<tr><td>Accepted values:</td><td>Auto, Left, Right</td></tr>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.String">String</a></td></tr>
<tr><td>Position:</td><td>7</td></tr>
<tr><td>Default value:</td><td>'Auto'</td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

<h4 id="-supportswildcards">**`-SupportsWildcards <String>`**</h4><br/>


<table>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.String">String</a></td></tr>
<tr><td>Position:</td><td>8</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>True</td></tr>
</table>

<h4 id="-quote">**`-Quote`**</h4><br/>
Quotes all the headers and values. If the Quote switch is set, all the delimeters are aligned.  (By default, each value is directly followed by a delimiter for compatibility reasons.)


<table>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.Management.Automation.SwitchParameter">SwitchParameter</a></td></tr>
<tr><td>Position:</td><td>Named</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

<h4 id="-code">**`-Code <String>`**</h4><br/>

Test () {
    Write-Host 'test'
}

This shows some Fenced code:
Footnote


<table>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.String">String</a></td></tr>
<tr><td>Position:</td><td>9</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

<h4 id="-fenced">**`-Fenced <String>`**</h4><br/>
This shows some Fenced code:

```Console
Test () {
    Write-Host 'test'
}
```
Footnote


<table>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.String">String</a></td></tr>
<tr><td>Position:</td><td>10</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

<h4 id="-pscode">**`-PSCode <String>`**</h4><br/>
Test2 () {
    Write-Host 'test'
}
This shows some PS > prefixed code:


<table>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.String">String</a></td></tr>
<tr><td>Position:</td><td>11</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

## Inputs
Csv (here) string or object list

## Outputs
String[]
## Related Links
* https://github.com/iRon7/Format-Csv
* [Test](https://en.wikipedia.org/wiki/Integer)
* 1: https://www.linguee.nl/engels-nederlands/vertaling/automatic+alignment.html
* [2]: https://en.wikipedia.org/wiki/Integer (Integer)

[1]: https://www.linguee.nl/engels-nederlands/vertaling/automatic+alignment.html
