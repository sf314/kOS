// Stephen Flores
// With the aid of some guy's code from YouTube
// This library implements the prediction of impact geoCoordinates. It tries to
// use as few locks as possible, so they're mostly gonna be function calls.

// Math functions
function Prediction_gConst {
    return Ship:Body:Mu/(Ship:Altitude + Ship:Body:Radius)^2.
}

function Prediction_findRoots {
	Declare Parameter Aterm.
	Declare Parameter Bterm.
	Declare Parameter Cterm.
	Local Root1 is 0.
	Local Root2 is 0.
	If (Bterm^2)-(4*Aterm*Cterm) > 0 {
		Set Root1 to (-Bterm + Sqrt((Bterm^2)-(4*Aterm*Cterm)))/(2*Aterm).
		Set Root2 to (-Bterm - Sqrt((Bterm^2)-(4*Aterm*Cterm)))/(2*Aterm).
	} Else If (Bterm^2)-(4*Aterm*Cterm) = 0 {
		Set Root1 to -Bterm / (2*Aterm).
		Set Root2 to Root1.
	}
    
	Return List(Root1, Root2).
}


// API
set Prediction_showArrows to true.

function Prediction_currentGeoCoords {
    local c is Kerbin:GeopositionOf(ship:position).
    vecdraw(ship:position, c:position, RGB(1, 0, 0), "P_cGC", 1.0, Prediction_showArrows, 1.0).
    return c.
}

function Prediction_impactGeoCoords {
    local impactTime is Prediction_findRoots(Prediction_gConst()/2, (-1)*verticalSpeed, (-1)*altitude)[0].
    local newGeopos is ship:body:geopositionOf(positionAt(ship, time:seconds + impactTime)).
    local newLat is newGeopos:lat.
    local newLng is newGeopos:lng - (impactTime * (360/Ship:Body:RotationPeriod)).
    local newGeopos is latlng(newLat, newLng).
    vecdraw(ship:position, newGeopos:position, RGB(0, 0, 1), "P_iGC", 1.0, Prediction_showArrows, 1.0).
    return newGeopos.
}


// Summary of findings:
// Kerbin:geopositionOf(position): Returns Geocoordinates of the spot associated with position.
// positionAt(ship, time): Returns predicted position of ship at given time. Is in still-planet reference frame. Does not account for rotation.
// Kerbin:altitudeOf(position): Returns accurate altitude of position.
// 