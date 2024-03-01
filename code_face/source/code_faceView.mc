import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.ActivityMonitor;
import Toybox.Activity;

class code_faceView extends WatchUi.WatchFace {

    var x_start_pos = 22;
    var y_start_pos = 38;
    var col_spacing = 10;
    var row_spacing = 20;
    var font_size = Graphics.FONT_SYSTEM_XTINY;
    var justify = Graphics.TEXT_JUSTIFY_LEFT;
    var sleeping = false;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc) {

        // colour background in black
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
        dc.clear();
        
        // update time and date strings
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var day_string = today.day;
        var month_string = today.month;
        var hour_string = today.hour;
        var min_string = today.min;
        var sec_string = today.sec;
        if (today.day.toNumber() < 10) {
            day_string = "0" + day_string;
        }
        if (today.month.toNumber() < 10) {
            month_string = "0" + month_string;
        }
        if (today.hour.toNumber() < 10) {
            hour_string = "0" + hour_string;
        }
        if (today.min.toNumber() < 10) {
            min_string = "0" + min_string;
        }
        var time_string = Lang.format("'$1$:$2$", [hour_string, min_string]);
        var date_string = Lang.format("'$1$/$2$'", [day_string, month_string]);

        if (sleeping) {
            time_string += ":--'"; // makes sure text underneath gets cleared
            dc.clear();
        }
        else {
            if (sec_string.toNumber() < 10) {
                sec_string = "0" + today.sec;
            }
            time_string += Lang.format(":$1$'", [sec_string]);
        }

        // update heart rate string
        var hr_string = "--";
        var HR = Activity.getActivityInfo().currentHeartRate;
        if (HR) {
            hr_string = Lang.format("$1$", [HR]);
        }
        else {
            hr_string = "--";
        }

        // update steps string
        var steps_string = "--";
        var steps = ActivityMonitor.getInfo().steps;
        if (steps) {
            steps_string = Lang.format("$1$", [steps]);
        }
        else {
            steps_string = "--";
        }

        // update battery string
        var battery = System.getSystemStats().battery;
        var battery_string = Lang.format("'$1$%'", [battery.format("%2d")]);

        // check sleeping to change text colour before writing to screen
        // var text_col = Graphics.COLOR_BLUE;
        // if (sleeping) {
        //     text_col = Graphics.COLOR_WHITE;
        // }
        // dc.setColor(text_col, Graphics.COLOR_BLACK);
        
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        
        // write all orange static text
        dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_BLACK);
        dc.drawText(x_start_pos, y_start_pos, font_size, "Class WatchFace:", justify);
        dc.drawText(x_start_pos + col_spacing, y_start_pos + row_spacing, font_size, "def", justify);
        dc.drawText(x_start_pos + 2*col_spacing + 72, y_start_pos + 2*row_spacing, font_size, "=", justify);
        dc.drawText(x_start_pos + 2*col_spacing + 72, y_start_pos + 3*row_spacing, font_size, "=", justify);
        dc.drawText(x_start_pos + 2*col_spacing + 113, y_start_pos + 4*row_spacing, font_size, "=", justify);
        dc.drawText(x_start_pos + 2*col_spacing + 77, y_start_pos + 5*row_spacing, font_size, "=", justify);
        dc.drawText(x_start_pos + 2*col_spacing + 82, y_start_pos + 6*row_spacing, font_size, "=", justify);

        // write all white static text
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(x_start_pos + col_spacing + 90, y_start_pos + row_spacing, font_size, "self", justify);
        dc.drawText(x_start_pos + 2*col_spacing, y_start_pos + 2*row_spacing, font_size, "self.time", justify);
        dc.drawText(x_start_pos + 2*col_spacing, y_start_pos + 3*row_spacing, font_size, "self.date", justify);
        dc.drawText(x_start_pos + 2*col_spacing, y_start_pos + 4*row_spacing, font_size, "self.heart_rate", justify);
        dc.drawText(x_start_pos + 2*col_spacing, y_start_pos + 5*row_spacing, font_size, "self.steps", justify);
        dc.drawText(x_start_pos + 2*col_spacing, y_start_pos + 6*row_spacing, font_size, "self.power", justify);

        // write all blue static text
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        dc.drawText(x_start_pos + col_spacing + 30, y_start_pos + row_spacing, font_size, "__init__(", justify);
        dc.drawText(x_start_pos + col_spacing + 120, y_start_pos + row_spacing, font_size, "):", justify);

        // write time string       
        dc.drawText(x_start_pos + 2*col_spacing + 87, y_start_pos + 2*row_spacing, font_size, time_string, justify);
        
        // write date string      
        dc.drawText(x_start_pos + 2*col_spacing + 87, y_start_pos + 3*row_spacing, font_size, date_string, justify);
        
        // write HR string        
        dc.drawText(x_start_pos + 2*col_spacing + 128, y_start_pos + 4*row_spacing, font_size, hr_string, justify);

        // write steps string
        dc.drawText(x_start_pos + 2*col_spacing + 90, y_start_pos + 5*row_spacing, font_size, steps_string, justify);

        // write battery string
        dc.drawText(x_start_pos + 2*col_spacing + 95, y_start_pos + 6*row_spacing, font_size, battery_string, justify);
    
    }

    function onHide() as Void {
    }

    // called when looking at watch
    function onExitSleep() {
        // dc.drawText(x_start_pos + 2*col_spacing, y_start_pos + 6*row_spacing, font_size, "hello", justify);
        sleeping = false;
        System.println("exited sleep");
    }

    // enter sleep when not looking at watch
    function onEnterSleep() {
        sleeping = true;
        System.println("entered sleep");
        WatchUi.requestUpdate();
    }

}
