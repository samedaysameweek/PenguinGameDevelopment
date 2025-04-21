/// @function ErrorLogger_Initialize()
/// @description Sets up the error logging system
function ErrorLogger_Initialize() {
    // Define log levels as a global enum
    global.LogLevel = {
        DEBUG: 0,
        INFO: 1,
        WARNING: 2,
        ERROR: 3,
        CRITICAL: 4
    };
    
    // Initialize log settings
    global.logLevel = global.LogLevel.DEBUG; // Current logging threshold
    global.logToFile = true;
    global.logFilePath = "game_log.txt";
    
    show_debug_message("[INFO] ErrorLogger initialized");
}

/// @function LogMessage(level, message, [context])
/// @param {Real} level The severity level of the message
/// @param {String} message The message to log
/// @param {Any} [context] Optional context data
function LogMessage(_level, _message, _context = undefined) {
    if (_level < global.logLevel) return;
    
    var _levelString = "";
    switch(_level) {
        case global.LogLevel.DEBUG: _levelString = "DEBUG"; break;
        case global.LogLevel.INFO: _levelString = "INFO"; break;
        case global.LogLevel.WARNING: _levelString = "WARNING"; break;
        case global.LogLevel.ERROR: _levelString = "ERROR"; break;
        case global.LogLevel.CRITICAL: _levelString = "CRITICAL"; break;
    }
    
    var _timestamp = string(current_year) + "-" + 
                     string(current_month) + "-" + 
                     string(current_day) + " " +
                     string(current_hour) + ":" + 
                     string(current_minute) + ":" + 
                     string(current_second);
                     
    var _logString = "[" + _timestamp + "] [" + _levelString + "] " + _message;
    if (_context != undefined) {
        _logString += "\nContext: " + string(_context);
    }
    
    show_debug_message(_logString);
    
    if (global.logToFile) {
        var _file = file_text_open_append(global.logFilePath);
        file_text_write_string(_file, _logString + "\n");
        file_text_close(_file);
    }
    
    // Return structured log entry
    return {
        timestamp: _timestamp,
        level: _level,
        levelString: _levelString,
        message: _message,
        context: _context
    };
} 