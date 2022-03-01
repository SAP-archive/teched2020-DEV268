CLASS /dmo/cl_gen_dev268_artifacts DEFINITION
 PUBLIC
  INHERITING FROM cl_xco_cp_adt_simple_classrun
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  PROTECTED SECTION.
    METHODS main REDEFINITION.
  PRIVATE SECTION.

    CONSTANTS:
      co_prefix         TYPE string         VALUE 'ZRAP_INVENTORY_',
      co_zlocal_package TYPE sxco_package   VALUE 'ZLOCAL',
      co_session_name   TYPE string VALUE 'DEV268'.


    DATA package_name  TYPE sxco_package VALUE  'ZRAP_INVENTORY_####'.
    DATA unique_number TYPE string VALUE '####'.
    DATA table_name_inventory  TYPE sxco_dbt_object_name.
    DATA dev_system_environment TYPE REF TO if_xco_cp_gen_env_dev_system.
    DATA transport TYPE sxco_transport .
    DATA transport_request      TYPE sxco_transport.

    METHODS generate_table  IMPORTING io_put_operation        TYPE REF TO if_xco_cp_gen_d_o_put
                                      table_name              TYPE sxco_dbt_object_name
                                      table_short_description TYPE if_xco_cp_gen_tabl_dbt_s_form=>tv_short_description .

    METHODS get_json_string RETURNING VALUE(json_string) TYPE string.

    METHODS get_unique_suffix             IMPORTING VALUE(s_prefix) TYPE string RETURNING VALUE(s_unique_suffix) TYPE string.
    METHODS create_transport              RETURNING VALUE(lo_transport) TYPE sxco_transport.
    METHODS create_package                IMPORTING VALUE(lo_transport) TYPE sxco_transport.


ENDCLASS.



CLASS /dmo/cl_gen_dev268_artifacts IMPLEMENTATION.

  METHOD main.
    DATA json_string TYPE string.


    unique_number        = get_unique_suffix( co_prefix ).

    package_name           = |ZRAP_INVENTORY_{ unique_number }|.

    package_name = to_upper( package_name ).

    out->write( | BEGIN OF GENERATION ({ cl_abap_context_info=>get_system_date(  ) } { cl_abap_context_info=>get_system_time(  ) } UTC) ... | ).
    out->write( | - Package: { package_name } | ).
    out->write( | - Group ID: { unique_number } | ).

    "create transport
    transport_request = create_transport(  ).
    "create package
    create_package( transport_request ).

    json_string = get_json_string(  ).

    DATA(lo_package) = xco_cp_abap_repository=>object->devc->for( package_name ).
*
*    IF NOT lo_package->exists( ).
*      RAISE EXCEPTION TYPE /dmo/cx_rap_generator
*        EXPORTING
*          textid   = /dmo/cx_rap_generator=>package_does_not_exist
*          mv_value = CONV #( package_name ).
*    ENDIF.

    table_name_inventory = |ZRAP_INVEN_{ unique_number }|.
    DATA(lo_table) = xco_cp_abap_repository=>object->tabl->for( CONV #( table_name_inventory ) ).

    IF lo_table->exists(  ) = abap_false.

*      DATA(lv_package_software_component) = lo_package->read( )-property-software_component->name.
*      DATA(lo_transport_layer) = lo_package->read(  )-property-transport_layer.
*      DATA(lo_transport_target) = lo_transport_layer->get_transport_target( ).
*      DATA(lv_transport_target) = lo_transport_target->value.
*      DATA(lo_transport_request) = xco_cp_cts=>transports->workbench( lo_transport_target->value  )->create_request( | create tables |  ).
*      DATA(lv_transport) = lo_transport_request->value.
*      transport = lv_transport.
*      dev_system_environment = xco_cp_generation=>environment->dev_system( lv_transport ).

      dev_system_environment     = xco_cp_generation=>environment->dev_system( transport_request ).

      DATA(lo_objects_put_operation) = dev_system_environment->create_put_operation( ).

      generate_table(
        EXPORTING
          io_put_operation        = lo_objects_put_operation
          table_name              = table_name_inventory
          table_short_description = | Inventory data group { unique_number }|
      ).

      DATA(lo_result) = lo_objects_put_operation->execute( ).

      out->write( | table { table_name_inventory } created| ).

      DATA(lo_findings) = lo_result->findings.
      DATA(lt_findings) = lo_findings->get( ).

      IF lt_findings IS NOT INITIAL.
        out->write( lt_findings ).
      ENDIF.

    ELSE.
      out->write( | table { table_name_inventory } already exists| ).
    ENDIF.



    "create RAP BO

    DATA(rap_generator) = NEW /dmo/cl_rap_generator( json_string ).
    DATA(todos) = rap_generator->generate_bo(  ).
    DATA(rap_bo_name) = rap_generator->root_node->rap_root_node_objects-service_binding.
    out->write( |RAP BO { rap_bo_name }  generated successfully| ).
    out->write( |Todo's:| ).
    LOOP AT todos INTO DATA(todo).
      out->write( todo ).
    ENDLOOP.


  ENDMETHOD.


  METHOD generate_table.

    DATA(lo_specification) = io_put_operation->for-tabl-for-database_table->add_object( table_name
                )->set_package( package_name
                 )->create_form_specification( ).

    lo_specification->set_short_description( table_short_description ).
    lo_specification->set_delivery_class( xco_cp_database_table=>delivery_class->l ).
    lo_specification->set_data_maintenance( xco_cp_database_table=>data_maintenance->allowed ).


    DATA database_table_field  TYPE REF TO if_xco_gen_tabl_dbt_s_fo_field  .

    database_table_field = lo_specification->add_field( 'CLIENT' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>data_element( 'MANDT' ) )->set_key_indicator( )->set_not_null( ).

    database_table_field = lo_specification->add_field( 'UUID' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>data_element( 'SYSUUID_X16' ) )->set_key_indicator( )->set_not_null( ).

    database_table_field = lo_specification->add_field( 'INVENTORY_ID' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>built_in_type->numc( 6  ) ).

    database_table_field = lo_specification->add_field( 'PRODUCT_ID' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>built_in_type->char( 10  ) ).


    database_table_field = lo_specification->add_field( 'QUANTITY' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>built_in_type->quan( iv_length = 13 iv_decimals = 3 ) ).
    database_table_field->currency_quantity->set_reference_table( CONV #( to_upper( table_name ) ) )->set_reference_field( 'QUANTITY_UNIT' ).

    database_table_field = lo_specification->add_field( 'QUANTITY_UNIT' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>built_in_type->unit( 3  ) ).

    database_table_field = lo_specification->add_field( 'PRICE' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>built_in_type->curr( iv_length = 16 iv_decimals = 2 ) ).
    database_table_field->currency_quantity->set_reference_table( CONV #( to_upper( table_name ) ) )->set_reference_field( 'CURRENCY_CODE' ).

    database_table_field = lo_specification->add_field( 'CURRENCY_CODE' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>built_in_type->cuky ).

    database_table_field = lo_specification->add_field( 'REMARK' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>built_in_type->char( 256  ) ).

    database_table_field = lo_specification->add_field( 'NOT_AVAILABLE' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>data_element( 'ABAP_BOOLEAN' ) ).

    database_table_field = lo_specification->add_field( 'CREATED_BY' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>data_element( 'SYUNAME' ) ).

    database_table_field = lo_specification->add_field( 'CREATED_AT' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>data_element( 'TIMESTAMPL' ) ).

    database_table_field = lo_specification->add_field( 'LAST_CHANGED_BY' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>data_element( 'SYUNAME' ) ).

    database_table_field = lo_specification->add_field( 'LAST_CHANGED_AT' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>data_element( 'TIMESTAMPL' ) ).

  ENDMETHOD.

  METHOD get_json_string.

    json_string ='{' && |\r\n|  &&
                 '  "implementationType": "managed_uuid",' && |\r\n|  &&
                 '  "namespace": "Z",' && |\r\n|  &&
                 |  "suffix": "_{ unique_number }",| && |\r\n|  &&
                 '  "prefix": "RAP_",' && |\r\n|  &&
                 |  "package": "{ package_name }",| && |\r\n|  &&
                 '  "datasourcetype": "table",' && |\r\n|  &&
                 '  "bindingtype": "odata_v2_ui",' && |\r\n|  &&
                 |  "transportrequest": "{ transport_request }",| && |\r\n|  &&
                 '  "hierarchy": {' && |\r\n|  &&
                 '    "entityName": "Inventory",' && |\r\n|  &&
                 |    "dataSource": "zrap_inven_{ unique_number }",| && |\r\n|  &&
                 '    "objectId": "inventory_id"    ' && |\r\n|  &&
                 '    }' && |\r\n|  &&
                 '}'.

  ENDMETHOD.


  METHOD create_package.
    DATA(lo_put_operation) = xco_cp_generation=>environment->dev_system( lo_transport )->for-devc->create_put_operation( ).
    DATA(lo_specification) = lo_put_operation->add_object( package_name )->create_form_specification( ).
    lo_specification->set_short_description( |{ co_session_name } tutorial package - { unique_number }| ).
    lo_specification->properties->set_super_package( co_zlocal_package )->set_software_component( co_zlocal_package ).
    lo_put_operation->execute( ).
  ENDMETHOD.

  METHOD create_transport.
    DATA(ls_package) = xco_cp_abap_repository=>package->for( co_zlocal_package )->read( ).
    DATA(lv_transport_layer) = ls_package-property-transport_layer->value.
    DATA(lv_transport_target) = ls_package-property-transport_layer->get_transport_target( )->value.
    DATA(lo_transport_request) = xco_cp_cts=>transports->workbench( lv_transport_target )->create_request( |{ co_session_name } generated tranport request - { unique_number }| ).

*    IF lo_transport_request->get_status(  ) = xco_cp_transport=>filter->status( xco_cp_transport=>status->modifiable ).
*        DATA(lo_transport_modifiable) = abap_true.
*    ENDIF.

    lo_transport = lo_transport_request->value.
  ENDMETHOD.

  METHOD get_unique_suffix.
    DATA: li_counter(4)    TYPE n,
          ls_counter       TYPE string,
          ls_package_name  TYPE sxco_package,
          is_valid_package TYPE abap_bool.


    s_unique_suffix = ''.
    is_valid_package = abap_false.
    li_counter = 0.
    ls_counter = li_counter.
    ls_package_name = s_prefix && ls_counter.

    WHILE is_valid_package = abap_false.
      "check package name
      DATA(lo_package) = xco_cp_abap_repository=>object->devc->for( ls_package_name ).
      IF NOT lo_package->exists( ).
        is_valid_package = abap_true.
        s_unique_suffix = ls_counter.
      ENDIF.
      li_counter = li_counter + 1.
      ls_counter = li_counter.
      ls_package_name = s_prefix && ls_counter.
    ENDWHILE.
  ENDMETHOD.

ENDCLASS.
