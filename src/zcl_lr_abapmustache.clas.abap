CLASS zcl_lr_abapmustache DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_bookingInfo,
             booking_id    TYPE string,
             connection_id TYPE string,
             flight_date   TYPE string,
             flight_price  TYPE string,
           END OF ty_bookingInfo.

    TYPES: BEGIN OF ty_connectionInfo,
             connection_id   TYPE string,
             airport_from_id TYPE string,
             airport_to_Id   TYPE string,
           END OF ty_connectionInfo.

    TYPES: BEGIN OF ty_travelInfo,
             travel_id   TYPE string,
             customer_id TYPE string,
             total_price TYPE string,
           END OF ty_travelInfo.

    TYPES ty_tt_bookinginfo TYPE STANDARD TABLE OF ty_bookinginfo WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_booking_information_out,
             travel     TYPE ty_travelinfo,
             booking    TYPE ty_tt_bookinginfo,
             connection TYPE ty_connectioninfo,
           END OF ty_booking_information_out.

    DATA mt_booking_information_out TYPE STANDARD TABLE OF ty_booking_information_out.
ENDCLASS.

CLASS zcl_lr_abapmustache IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    SELECT * FROM /dmo/travel INTO TABLE @DATA(lt_travel) UP TO 10 ROWS.
    SELECT * FROM /dmo/booking
        FOR ALL ENTRIES IN @lt_travel
        WHERE travel_id = @lt_travel-travel_id
        INTO TABLE @DATA(lt_booking).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<fs_travel>).
      APPEND INITIAL LINE TO mt_booking_information_out ASSIGNING FIELD-SYMBOL(<fs_out>).
      <fs_out>-travel = CORRESPONDING #( <fs_travel> ).
      LOOP AT lt_booking INTO DATA(ls_booking) WHERE travel_id = <fs_travel>-travel_id .
        APPEND INITIAL LINE TO <fs_out>-booking ASSIGNING FIELD-SYMBOL(<ls_data>).
        <ls_data> = CORRESPONDING #( ls_booking ).
      ENDLOOP.

    ENDLOOP.

    TRY.
        DATA(lo_mustache) =  zcl_mustache=>create(
        '<h3>Travel related bookings for Travel ID {{travel-travel_id}} - ' && ' Customer {{travel-customer_id}} </h3> </br>' &&
        '<table>' &&
        '<tr><th>Booking ID</th><th>Flight Price</th>' &&
        '{{#booking}}' &&
        '<tr><td>{{booking_id}}</td><td>{{flight_price}}</td></tr>' &&
        '{{/booking}} ' &&
        '</table>') .
        DATA(lv_res) = lo_mustache->render( mt_booking_information_out ).
        out->write( lv_res ).
        out->write( 'Ended' ).

      CATCH zcx_mustache_error INTO DATA(error).
        "handle exception
        out->write( error->msg ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
