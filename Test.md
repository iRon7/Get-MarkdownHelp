# Test.ps1
```
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
```
```
## [Examples](#examples)
### Example 1: Named Example
```
```
```
```
```
```
```
```
```
```
```
```
```
```
```
```
```
### Example 2:
```
## [Parameter](#parameter)
### `-InputObject <Object>`
```
```

<table>
<tr><td>Type:</td><td>[Object](https://docs.microsoft.com/en-us/dotnet/api/System.Object)</td></tr>
<tr><td>Position:</td><td>0</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

### `-Delimiter <Char>`
```
```
```
```
```
```

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
```
```
```
```
```
```

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
```
```

<table>
<tr><td>Type:</td><td>[SwitchParameter](https://docs.microsoft.com/en-us/dotnet/api/System.Management.Automation.SwitchParameter)</td></tr>
<tr><td>Position:</td><td>Named</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

### `-Code <String>`
```
```
```
```
```

<table>
<tr><td>Type:</td><td>[String](https://docs.microsoft.com/en-us/dotnet/api/System.String)</td></tr>
<tr><td>Position:</td><td>9</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

### `-Fenced <String>`
```
This shows some Fenced code:

```Console
Test () {
```
```
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
```
```
```
```

<table>
<tr><td>Type:</td><td>[String](https://docs.microsoft.com/en-us/dotnet/api/System.String)</td></tr>
<tr><td>Position:</td><td>11</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

## [Inputs](#Inputs)
```
## [Outputs](#Outputs)
```
## [Related Links](#RelatedLinks)
* https://github.com/iRon7/Format-Csv
* [Test](https://en.wikipedia.org/wiki/Integer)
* 1: https://www.linguee.nl/engels-nederlands/vertaling/automatic+alignment.html
* [2]: https://en.wikipedia.org/wiki/Integer (Integer)

[1]: https://www.linguee.nl/engels-nederlands/vertaling/automatic+alignment.html
