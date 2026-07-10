//%attributes = {}
/*
$date:=Current date  // Date pour laquelle la phase de la lune est calculée

$julian_day:=(Year of($date)*365)+(Month of($date)*30)+(Day of($date)-678912)  // Convertir la date en jours julien

$days_since_2000:=$julian_day-2451545  // Calculer le nombre de jours depuis le 1er janvier 2000

$n:=$days_since_2000/36525  // Calculer la fraction d'année julienne depuis le 1er janvier 2000
$l:=(280.46+0.9856474*$days_since_2000)%360  // Calculer la longitude moyenne de la lune en degrés
$lp:=(218.32+13.1763966*$days_since_2000)%360  // Calculer l'anomalie moyenne de la lune en degrés
$d:=($lp-$l+360)%360  // Calculer la différence entre la longitude et l'anomalie moyenne en degrés
$f:=(83.353+0.1114036*$days_since_2000)%360  // Calculer l'élongation moyenne de la lune en degrés
$longitude:=$l+1.915*Sin($d)+0.02*Sin(2*$d)  // Calculer la longitude vraie de la lune en degrés
$latitude:=$f-0.026*Sin($d)  // Calculer la latitude vraie de la lune en degrés
$distance:=(60.4-3.3*Cos($d))-(0.6*Cos(2*$d))-(0.5*Cos($f-$d))  // Calculer la distance de la lune en kilomètres
$phase:=((1-Cos($f-$l))/2)*100  // Calculer la phase de la lune en pourcentage

ALERT("Phase de la lune le "+String($date)+" : "+String($phase)+"%")  // Afficher la phase de la lune pour la date donnée
*/

/*
var $date : Date:=Current date  // Date pour laquelle la phase de la lune est calculée

var $julian_day : Real:=(Year of($date)*365)+(Month of($date)*30)+(Day of($date)-678912)  // Convertir la date en jours julien

var $days_since_2000 : Real:=$julian_day-2451545  // Calculer le nombre de jours depuis le 1er janvier 2000

var $n : Real:=$days_since_2000/36525  // Calculer la fraction d'année julienne depuis le 1er janvier 2000
var $l : Real:=(280.46+0.9856474*$days_since_2000)%360  // Calculer la longitude moyenne de la lune en degrés
var $lp : Real:=(218.32+13.1763966*$days_since_2000)%360  // Calculer l'anomalie moyenne de la lune en degrés
var $d : Real:=($lp-$l+360)%360  // Calculer la différence entre la longitude et l'anomalie moyenne en degrés
var $f : Real:=(83.353+0.1114036*$days_since_2000)%360  // Calculer l'élongation moyenne de la lune en degrés
var $longitude : Real:=$l+1.915*Sin($d)+0.02*Sin(2*$d)  // Calculer la longitude vraie de la lune en degrés
var $latitude : Real:=$f-0.026*Sin($d)  // Calculer la latitude vraie de la lune en degrés
var $distance : Real:=(60.4-3.3*Cos($d))-(0.6*Cos(2*$d))-(0.5*Cos($f-$d))  // Calculer la distance de la lune en kilomètres
var $phase : Real:=((1-Cos($f-$l))/2)*100  // Calculer la phase de la lune en pourcentage

ALERT("Phase de la lune le "+String($date)+" : "+String($phase)+"%")  // Afficher la phase de la lune pour la date donnée
*/
