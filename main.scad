$fn = $preview ? 32 : 128;

// change log
//
// semver process:
// major - significant changes
// minor - add new components or negative volumes
// patch - change parameteric values for existing components
//
// 0.1.0 - initial release, verified proportions against reference model
// 0.2.0 - added negative volumes for metric hardware, added version stamp
// 0.2.1 - adjust back_thinkness to a static value, increase size of bolt hole to fit M3 bolts, moved negative volumes for hardware 
// 0.3.0 - add bottom finger, the increased thinkness of the finger from 3.5 to 4, move version stamp

version = "0.3.0";


nut_thickness = 3.1;
nut_width = 7.0;

hanger_width = 15;

back_thinkness = nut_thickness * 2 + 1;

back_length = 82;  

arm_inner_length = 12;
arm_outer_length = arm_inner_length + back_thinkness;

slot_finger_width = 4;  // reference mode was 3.0, previous version was 3.5
slot_finger_length = 7.5;

bolt_shaft_radius = 3.5/2;

bottom_finger_total_length = 10;

module silhouette()  {


polygon(points=[
    [0,0],
    [arm_outer_length,0],
    [arm_outer_length,back_length],
    [slot_finger_width,back_length],
    [slot_finger_width,back_length+ slot_finger_length],
    [0,back_length+ slot_finger_length],
    [0,back_length - back_thinkness],
    [arm_inner_length, back_length - back_thinkness],
    [arm_inner_length, back_thinkness],
    [slot_finger_width, back_thinkness],
    [slot_finger_width, bottom_finger_total_length],
    [0, bottom_finger_total_length],
    [0, back_thinkness],
    ]);

}

// the y vector is modified with a offset based on testing the 1.2.0 version to align with the top of the basket plate.
hardware_translate = [arm_inner_length + nut_thickness/2, back_length/2 + 10.5, 0];

difference() {
    
    linear_extrude(height=hanger_width, center=true, convexity=10)
        silhouette();

    translate(hardware_translate) { 
        rotate([0, 90, 0]) {
            #nut();    
            #bolt_hole();
        }
    }

    version_stamp();

}




module nut() {
    linear_extrude(height=nut_thickness+ 0.125, center=true, convexity=10)
    resize([0, nut_width + 0.125,0], true)
    circle(r=10, 
        $fn=6);
}



module bolt_hole() {
    cylinder(h=hanger_width + 1, r=bolt_shaft_radius + 0.25, center=false);
}

module version_stamp() {
    translate([arm_inner_length, back_thinkness + 7, 0])
    rotate([90,0,-90])
    #linear_extrude(height=2, center=true, convexity=10)
    text(version, size=4, valign="center", halign="right", font="Liberation Sans:style=Bold");
}