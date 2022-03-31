CREATE FUNCTION plschemeu_call_handler() RETURNS language_handler
    LANGUAGE c AS 'MODULE_PATHNAME';

CREATE LANGUAGE plschemeu
    HANDLER plschemeu_call_handler;
