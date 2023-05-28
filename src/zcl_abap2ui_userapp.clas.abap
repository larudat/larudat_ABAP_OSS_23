CLASS  zcl_abap2ui_userapp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA:cur_user TYPE string,
         cur_Date TYPE string.

    DATA check_initialized TYPE abap_bool.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_abap2ui_userapp IMPLEMENTATION.
  METHOD z2ui5_if_app~main.
    IF check_initialized = abap_false.
      check_initialized = abap_true.
      cur_date = cl_abap_context_info=>get_system_date( ).
      TRY.
          cur_User = cl_abap_context_info=>get_user_formatted_name(  ).
        CATCH cx_abap_context_info_error.
          "handle exception
      ENDTRY.
    ENDIF.

    CASE client->get( )-event.
      WHEN 'BUTTON_POST'.
        client->popup_message_toast( | App executed on { cur_date } by { cur_user }| ).
    ENDCASE.

    client->set_next( VALUE #( xml_main = z2ui5_cl_xml_view=>factory(
        )->shell(
        )->page( title = 'abap2UI5 - zcl_abap2ui_userapp'
            )->simple_form( title = 'User Input App' editable = abap_true
                )->content( ns = `form`
                    )->title( 'Input'
                    )->label( 'User'
                    )->input( value = client->_bind( cur_User )
                    )->label( 'Date'
                    )->date_picker( value = client->_bind( cur_date )
                    )->button(
                        text  = 'post'
                        press = client->_event( 'BUTTON_POST' )
         )->get_root( )->xml_get( ) ) ).
  ENDMETHOD.

ENDCLASS.
