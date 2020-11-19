

function Set-HraciaPlocha {
    [CmdletBinding()]
    param (
        [int]
        $Xsize,
        [int]
        $Ysize
    )
    $plocha = New-Object 'object[,,]' $Xsize, $Ysize, 1
  
    for ($t = 0; $t -lt $Ysize; $t++) {
        #$line = ""
        for ($i = 0; $i -lt $Xsize; $i++) {
            $plocha[$i, $t, 0] = "O"
            #$line += $plocha[$i,$t,0]         
        }
        #$line
    }

    $myHashtable = @{
        Xsize = $Xsize
        Ysize = $Ysize
        array = $plocha
    }
    $myObject = [pscustomobject]$myHashtable

    return $myObject 
}

function Show-HraciaPlocha {
    [CmdletBinding()]
    param (
        $HraciaPlocha
    )
    
    for ($t = 0; $t -lt $HraciaPlocha.Ysize; $t++) {
        $line = ""
        for ($i = 0; $i -lt $HraciaPlocha.Xsize; $i++) {
            $line += $HraciaPlocha.array[$i, $t, 0]         
        }
        $line
    }
}

function Set-HraciaPlochaBorders {
    param (
        $HraciaPlocha
    )
    $HraciaPlocha.array[0, 0, 0] = "X"
    $HraciaPlocha.array[0, 7, 0] = "X"
    $HraciaPlocha.array[7, 0, 0] = "X"
    $HraciaPlocha.array[7, 7, 0] = "X"
    Return $HraciaPlocha
}


function Find-FirstEmptySpace {
    param (
        $HraciaPlocha
    )
    
    
    $foundEmpty = $false
    $row = 0
    $column = 0
    DO {
        DO {
            Write-Host "[$row,$column,$($HraciaPlocha.Array[$row, $column, 0])]"
            if ($HraciaPlocha.Array[$row, $column, 0] -eq "O") { $foundEmpty = $true }
            
            $column++
            
        } Until (($foundEmpty) -or ($column -eq ($HraciaPlocha.Xsize)))
        if (!$foundEmpty) { $column = 0 }
        $row++
        
    } Until (($foundEmpty) -or ($row -eq ($HraciaPlocha.Ysize)))

    $myHashtable = @{
        Row    = $column - 1
        Column = $row - 1
    }
    $cursor = [pscustomobject]$myHashtable  
    Return $cursor
}

function Write-SingleToPlocha {
    param (
        $HraciaPlocha,
        $cursor,
        $entry
    )

    $HraciaPlocha.Array[$cursor.Column, $cursor.Row, 0] = $entry

    Return $HraciaPlocha

}

function Get-Utvar {
    param (
        $RowsSize,
        $columnsSize
    )
    $myHashtable = @{
        RowSize    = $RowsSize
        ColumnSize = $columnsSize
    }
    $myObject = [pscustomobject]$myHashtable   
    Return $myObject
}


function Write-UtvarOnCursor {
    param (
        $cursor,
        $utvar,
        $HraciaPlocha
    )
    $maxColumn = $utvar.ColumnSize + $cursor.Column
    $maxRows = $utvar.RowSize+$cursor.Row
   for ($rws = $cursor.Row; $rws -lt $maxRows; $rws++) {
        for ($i = $cursor.Column; $i -lt $maxColumn ; $i++) {
            $HraciaPlocha.array[$i,$rws, 0] = "A"
        }
   }
    
}


function Test-UtvarOnCursor {
    param (
        $cursor,
        $utvar,
        $HraciaPlocha
    )
    $result = @()
    $maxColumn = $utvar.ColumnSize + $cursor.Column
    $maxRows = $utvar.RowSize+$cursor.Row
   for ($rws = $cursor.Row; $rws -lt $maxRows; $rws++) {
        for ($i = $cursor.Column; $i -lt $maxColumn ; $i++) {
            if ($HraciaPlocha.Array[$i,$rws, 0] -eq "O") { $result+="T"} else {$result+="F"}
        }
   }

if ($result -contains "F") {$test = $false} else {$test=$true}
Return $test

}


$MyPlocha = Set-HraciaPlocha 8 8
$MyPlocha = Set-HraciaPlochaBorders $MyPlocha
Show-HraciaPlocha $MyPlocha
$cursor = Find-FirstEmptySpace $MyPlocha
Write-SingleToPlocha -HraciaPlocha $MyPlocha -cursor $cursor -entry "E"

$cursor.Row = 4
$cursor.Column = 4
$utvar = get-utvar 1 1
Write-UtvarOnCursor -HraciaPlocha $MyPlocha -cursor $cursor -utvar $utvar
Test-UtvarOnCursor -HraciaPlocha $MyPlocha -cursor $cursor -utvar $utvar



for ($i = 1; 10; $i++) {
    $cursor = Find-FirstEmptySpace $MyPlocha
    Write-SingleToPlocha -HraciaPlocha $MyPlocha -cursor $cursor -entry "E"
    Show-HraciaPlocha $MyPlocha
}