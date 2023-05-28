class ZCL_LR_A2UI5_TEST1 definition
  public
  create public .

public section.

  interfaces IF_HTTP_SERVICE_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_LR_A2UI5_TEST1 IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.
   z2ui5_cl_http_handler=>client = VALUE #(
      t_header = request->get_header_fields( )
      t_param  = request->get_form_fields( )
      body     = request->get_text( ) ).

   DATA(lv_resp) = SWITCH #( request->get_method( )
      WHEN 'GET'  THEN z2ui5_cl_http_handler=>http_get( )
      WHEN 'POST' THEN z2ui5_cl_http_handler=>http_post( ) ).

   response->set_status( 200 )->set_text( lv_resp ).
  endmethod.
ENDCLASS.
