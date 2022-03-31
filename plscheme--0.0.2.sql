CREATE FUNCTION plscheme_call_handler() RETURNS language_handler
    LANGUAGE c AS 'MODULE_PATHNAME';

CREATE LANGUAGE plscheme
    HANDLER plscheme_call_handler;
