package haxe.ui.components;

import haxe.ui.behaviours.Behaviour;
import haxe.ui.core.Component;
import haxe.ui.layouts.DefaultLayout;
import haxe.ui.geom.Point;
import haxe.ui.util.Variant;

@:composite(HorizontalRangeLayout)
class HorizontalRange extends Range {
    //***********************************************************************************************************
    // Private API
    //***********************************************************************************************************
    @:call(HorizontalRangePosFromCoord)         private override function posFromCoord(coord:Point):Float;
}

//***********************************************************************************************************
// Behaviours
//***********************************************************************************************************
@:dox(hide) @:noCompletion
class HorizontalRangePosFromCoord extends Behaviour {
    public override function call(pos:Any = null):Variant {
        var range = cast(_component, Range);
        var p = cast(pos, Point);
        var xpos = p.x - range.layout.paddingLeft;
        
        var ucx = range.layout.usableWidth;

        if (xpos >= ucx) {
            xpos = ucx;
        }
        
        var m:Float = range.max - range.min;
        var v:Float = xpos;
        var p:Float = range.min + ((v / ucx) * m);

        return p;
    }
}

//***********************************************************************************************************
// Composite Layout
//***********************************************************************************************************
@:dox(hide) @:noCompletion
class HorizontalRangeLayout extends DefaultLayout {
    public override function resizeChildren() {
        super.resizeChildren();
        
        var range:Range = cast(component, Range);
        var value:Component = findComponent('${range.cssName}-value');
        
        var ucx:Float = usableWidth;
        var cx:Float = ((range.end - range.start) - range.min) / (range.max - range.min) * ucx;

        if (cx < 0) {
            cx = 0;
        } else if (cx > ucx) {
            cx = ucx;
        }

        if (cx == 0) {
            value.width = 0;
            value.hidden = true;
        } else {
            value.width = cx;
            value.hidden = false;
        }
    }

    public override function repositionChildren() {
        var range:Range = cast(component, Range);
        var value:Component = findComponent('${range.cssName}-value');
        
        var ucx:Float = usableWidth;
        var x = (range.start - range.min) / (range.max - range.min) * ucx;

        value.left = paddingLeft + x;
        value.top = paddingTop;
    }    
}
