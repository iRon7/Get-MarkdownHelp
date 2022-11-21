# Test.ps1
Formats (aligns) a Csv table

## Description
This cmdlet makes a Csv file or list better human readable by aligning the columns in a way that the resulted
Csv format is still a valid as input for the [`ConvertFrom-Csv`](https://go.microsoft.com/fwlink/?LinkID=2096830) cmdlet.
See also: [`-Quote`](#-Quote).

## Examples
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

## Parameter
#### <a id="-inputobject">**`-InputObject <Object>`**</a>
Specifies the CSV strings to be formatted or the objects that are converted to CSV formatted strings.
You can also pipe objects to [`ConvertTo-CSV`](https://go.microsoft.com/fwlink/?LinkID=2096832).


<table>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.Object">Object</a></td></tr>
<tr><td>Position:</td><td>0</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

#### <a id="-delimiter">**`-Delimiter <Char>`**</a>

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

#### <a id="-validatecount">**`-ValidateCount <Int32>`**</a>


<table>
<tr><td>Accepted length:</td><td>-1</td></tr>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.Int32">Int32</a></td></tr>
<tr><td>Position:</td><td>2</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

#### <a id="-validatelength">**`-ValidateLength <Int32>`**</a>


<table>
<tr><td>Accepted length:</td><td>-1</td></tr>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.Int32">Int32</a></td></tr>
<tr><td>Position:</td><td>3</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

#### <a id="-validatepattern">**`-ValidatePattern <String>`**</a>


<table>
<tr><td>Accepted pattern:</td><td><code>^[a-z]+$</code></td></tr>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.String">String</a></td></tr>
<tr><td>Position:</td><td>4</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

#### <a id="-validaterange">**`-ValidateRange <Int32>`**</a>


<table>
<tr><td>Accepted range:</td><td>-8</td></tr>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.Int32">Int32</a></td></tr>
<tr><td>Position:</td><td>5</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

#### <a id="-validatescript">**`-ValidateScript <String>`**</a>


<table>
<tr><td>Accepted script condition:</td><td><code>$_ -eq 20</code></td></tr>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.String">String</a></td></tr>
<tr><td>Position:</td><td>6</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

#### <a id="-validateset">**`-ValidateSet <String>`**</a>

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

#### <a id="-supportswildcards">**`-SupportsWildcards <String>`**</a>


<table>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.String">String</a></td></tr>
<tr><td>Position:</td><td>8</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>True</td></tr>
</table>

#### <a id="-quote">**`-Quote`**</a>
Quotes all the headers and values. If the Quote switch is set, all the delimeters are aligned.  (By default, each value is directly followed by a delimiter for compatibility reasons.)


<table>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.Management.Automation.SwitchParameter">SwitchParameter</a></td></tr>
<tr><td>Position:</td><td>Named</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

#### <a id="-code">**`-Code <String>`**</a>
This shows some code:

```PowerShell
Test () {
    Write-Host 'test'
}
```
Footnote


<table>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.String">String</a></td></tr>
<tr><td>Position:</td><td>9</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

#### <a id="-fenced">**`-Fenced <String>`**</a>
This shows some **fenced** code:

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

#### <a id="-pscode">**`-PSCode <String>`**</a>
This shows some PS > prefixed code:

```PowerShell
 Test2 () {
     Write-Host 'test'
 }
```

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
```PowerShell
String[]
```
## Related Links
* https://github.com/iRon7/Format-Csv
* [Test](https://en.wikipedia.org/wiki/Integer)
* 1: https://www.linguee.nl/engels-nederlands/vertaling/automatic+alignment.html
* [2]: https://en.wikipedia.org/wiki/Integer (Integer)

[1]: https://www.linguee.nl/engels-nederlands/vertaling/automatic+alignment.html
