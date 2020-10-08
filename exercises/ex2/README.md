# Exercise 2

When creating a new entry with your inventory application you see that there is no value help for the field ProductId. 
Since this information resides in a SAP S/4 HANA backend we will it retrieve via OData.

 ![No value help](images/1010.png)

In this exercise you will thus learn how to consume an OData Service of your on premise system in order to fetch business partner data. You will then learn how to expose this data as a value help for the Inventory entity.

In this exercise, we will ...

  - Create a Service Consumption Model for the on premise OData Service
  - Create a console application to test the OData Service call
  - Create a Custom Entity and implement its custom query
  - Expose your Custom Entity with your existing OData Service
  - Add the Custom Entity as a value help for the ProductId for your inventory application


> Please note:
> Since it must be possible to run this demo on the trial systems where no destination service is available we cannot use RFC calls to retrieve data from a backend system. We  have rather to use services that are publically available in the Internet. In our demo we will thus use an OData Service that is available in the SAP Gateway Demo System ES5  and that does not require any authentication.



## Create the Service Consumption Model

In this step we will generate a so called Service Consumption Model.
This type of object takes an external interface description as its input. 
Currently OData and SOAP are supported. With the upcoming release 2011 it is planned to support Service Consumption Modells for RFC based communication  as well.
Based on the information found in the $metadata file or the wsdl file appropriate repository objects are generated (OData Client proxy or SOAP proxy objects).
Using these objects you will be able to write ABAP code that lets you consume remote OData or SOAP services.
 
 
We start by creating a service consumption model for an OData service that provides demo product data. This service resides on the public SAP Gateway System ES5 and does not require any authentication

> Please note:
> Since it must be possible to run this demo on the trial systems where no destination service is available we have to use services that are publically available in the Internet. In our demo we will thus use an OData Service that is available in the SAP Gateway Demo System ES5 and that does not require any authentication.


1. The $metadata file of the OData service that we want to consume must be uploaded in file format. You have hence to download it first.
 
 - Click on the following URL https://sapes5.sapdevcenter.com/sap/opu/odata/sap/ZPDCDS_SRV/$metadata
 - Download the $metadata file to your computer, you will need it later in this exercise.

2. Switch to ADT and right click on your package . Select **New > Other ABAP Repository Object**.

 ![New ABAP Repository Object 1](images/1020.png)

2. In the New ABAP Repository Object dialogue do the following

  -  Start to type **`Service`**
  -  In the list of objects select **Service Conumption Model**
  -  Click **Next**
 
  ![New ABAP Repository Object 2](images/1030.png)

4. The **New Service Consumption Model** dialogue opens. Here enter the following data:

   - Name: **ZSC_RAP_PRODUCTS_#### ``**
   - Description: **'Products from ES5`##
   - Remote Consumption Model: **`OData`** (to be selected from the drop down box)
   
   > **Caution**
   
   > Be sure that you have selected **`OData`** as the **Remote Consumption Mode** from the drop down box. We will create a service consumption model for a SOAP web service in the following exercise.
   
    ![New Service Consumption Model](images/1040.png)

5. The $metadata file of the OData service that you want to consume must be uploaded in file format. If you have not yet downloaded the $metadata file you have to do this now.

   - Click **Browse** to select the $metadata file that you have downloaded earlier in this exercise
   - Prefix: **`RAP_#### _`** 

> **Please note**

> The prefix that you have entered will be added to the names of the repository objects that are generated, namely the **Service Consumption Model** and the (one or more) **abstract entity**. 
> If you don't select a prefix and if the wizard finds out that there would be name clashes the wizard will propse unique names by adding arbritrary characters to the repository object names. In any case you will be able to change the values that will be proposed by this wizard.

 ![OData consumption proxy](images/1050.png)

6. Check the **ABAP Artifact Name** and click **Next**.

> You will notice that the name of the ABAP artifact has been set to **`ZRAP_####_SEPMRA_I_PRODUCT_E`** since we have provided the prefix **RAP_#### _** 

> If you have not provided a prefix the ABAP Artifact Name might contain several arbritray characters that have been added to the name ZSEPMRA_I_PRODUCT. This can happen if other users in the same system have already imported the same $metadata file. In order to avoid name clashes the wizard then adds arbritrary characters so that a unique name for the ABAP artifact is ensured.

![Define Entity Set](images/1060.png)

7. The wizard will now list the repository objects that will be generated, namely a service definition and an abstract entity in addition to the service consumption model.
  - The Service Definition: **ZSC_RAP_PRODUCTS_####**
  - The abstract entity: **ZRAP_####_SEPMRA_I_PRODUCT_E**

Click **Next**.

![ABAP Artifact Genertion List](images/1070.png)

8. Selection of transport request
  - Select or create a transport request
  - Press **Finish**

![ABAP Artifact Genertion List](images/1080.png)

9. Let us shortly investigate the service consumption model. 

For each operation (**Read List**, **Read**, **Create**, **Update** and **Delete**) some sample code has been created that you can use when you want to call the OData Service with one of these operations. Since we want to retrieve a list of Product-IDs, we will select the operation **Read List** and click on the button **Copy to Clipboard**. We will use this code in the following step where we create a console application to test the call to the remote OData service. 
  
  > We will later in this exercise use this code also to retrieve a list of ProductIds for your value help.
  
 ![Code sample for entity access](images/1090.png) 

## Create a console application to test the OData service

We can now test the service consumption model by creating a small console application **ZCL_CE_RAP_PRODUCTS_####** that implements the interface **if_oo_adt_classrun**.
This is a useful additional step since this way it is easier to check whether the OData consumption works and debugging a console application is much easier than trying out your coding in the full fledged RAP business object.

> **Please note**

> We will use this class at a later stage also as an implementation for our custom query and we hence choose a name that already contains the name of the to be created custom entity.

1. Right click on the folder **Source Code Library** and select **New > ABAP Class**.
   
   ![New ABAP class](images/1100.png)

2. The **New ABAP class** dialogue opens. Here you have to enter the following:

   - Name: ZCL_CE_RAP_PRODUCTS_1234
   - Description: Query implementation custom entity 
   - Click **Add**
   
   The **Add ABAP Interface** dialogue opens.
   
   - Start to type **`if_oo`**
   - Select **`IF_OO_ADT_CLASSRUN`** from the list of matching items
   - Press **OK** or double-click on **IF_OO_ADT_CLASSRUN**
   
   ![New ABAP class](images/1110.png)
   
   
3. Check the input and press **Next**

![New ABAP class](images/1120.png)

4. Selection of transport request

   - Select or create a transport request
   - Click **Finish**

![Selection of transport request](images/1130.png)

   

Navigating back to the service consumption model we use the copy to clipboard button to copy the sample code for the ReadList operation into the main method of our newly created class.
Since it is not possible to leverage the destination service in the trial systems, we will use the method create_by_http_destination which allows to create a http client object based on the target URL.
Here we take the root URL https://sapes5.sapdevcenter.com of the ES5 system since the relative URL will be added when creating the OData client proxy.

5. Add an implementation for the method main

  You will see the warning **Implementation missing for method "IF_OO_ADT_CLASSRUN~MAIN". "IF_OO_ADT_CLASSRUN~MAIN"**. 

6. Add a types and method definition

In the public section of the definition section of your class add the following code

<pre>
CLASS zcl_ce_rap_products_#### DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    TYPES t_product_range TYPE RANGE OF zrap_####_sepmra_i_product_e-product.
    TYPES t_business_data TYPE TABLE OF zrap_####_sepmra_i_product_e.

    METHODS get_products
      IMPORTING
        it_filter_cond   TYPE if_rap_query_filter=>tt_name_range_pairs   OPTIONAL
        top              TYPE i OPTIONAL
        skip             TYPE i OPTIONAL
      EXPORTING
        et_business_data TYPE  t_business_data
      RAISING
        /iwbep/cx_cp_remote
        /iwbep/cx_gateway
        cx_web_http_client_error
        cx_http_dest_provider_error
      .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.
</pre>

7. Add the following code into the implementation of your main method

<pre>
  METHOD if_oo_adt_classrun~main.

    DATA business_data TYPE TABLE OF zrap_####_sepmra_i_product_e.
    DATA filter_conditions  TYPE if_rap_query_filter=>tt_name_range_pairs .
    DATA ranges_table TYPE if_rap_query_filter=>tt_range_option .
    ranges_table = VALUE #( (  sign = 'I' option = 'GE' low = 'HT-1200' ) ).
    filter_conditions = VALUE #( ( name = 'PRODUCT'  range = ranges_table ) ).

    TRY.
        get_products(
          EXPORTING
            it_filter_cond    = filter_conditions
            top               =  3
            skip              =  1
          IMPORTING
            et_business_data  = business_data
          ) .
        out->write( business_data ).
      CATCH cx_root INTO DATA(exception).
        out->write( cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ) ).
    ENDTRY.

  ENDMETHOD.
</pre>

8. and finally add an implementation for the method **get_products**. 

<pre>
METHOD get_products.

    DATA: filter_factory   TYPE REF TO /iwbep/if_cp_filter_factory,
          filter_node      TYPE REF TO /iwbep/if_cp_filter_node,
          root_filter_node TYPE REF TO /iwbep/if_cp_filter_node.

    DATA: http_client        TYPE REF TO if_web_http_client,
          odata_client_proxy TYPE REF TO /iwbep/if_cp_client_proxy,
          read_list_request  TYPE REF TO /iwbep/if_cp_request_read_list,
          read_list_response TYPE REF TO /iwbep/if_cp_response_read_lst.

    DATA(http_destination) = cl_http_destination_provider=>create_by_url( i_url = 'https://sapes5.sapdevcenter.com' ).
    http_client = cl_web_http_client_manager=>create_by_http_destination( i_destination = http_destination ).

    odata_client_proxy = cl_web_odata_client_factory=>create_v2_remote_proxy(
      EXPORTING
        iv_service_definition_name = 'ZSC_RAP_PRODUCTS_####'
        io_http_client             = http_client
        iv_relative_service_root   = '/sap/opu/odata/sap/ZPDCDS_SRV/' ).

    " Navigate to the resource and create a request for the read operation
    read_list_request = odata_client_proxy->create_resource_for_entity_set( 'SEPMRA_I_PRODUCT_E' )->create_request_for_read( ).

    " Create the filter tree
    filter_factory = read_list_request->create_filter_factory( ).
    LOOP AT  it_filter_cond  INTO DATA(filter_condition).
      filter_node  = filter_factory->create_by_range( iv_property_path     = filter_condition-name
                                                              it_range     = filter_condition-range ).
      IF root_filter_node IS INITIAL.
        root_filter_node = filter_node.
      ELSE.
        root_filter_node = root_filter_node->and( filter_node ).
      ENDIF.
    ENDLOOP.

    IF root_filter_node IS NOT INITIAL.
      read_list_request->set_filter( root_filter_node ).
    ENDIF.

    IF top > 0 .
      read_list_request->set_top( top ).
    ENDIF.

    read_list_request->set_skip( skip ).

    " Execute the request and retrieve the business data
    read_list_response = read_list_request->execute( ).
    read_list_response->get_business_data( IMPORTING et_business_data = et_business_data ).

  ENDMETHOD.
</pre>

## Create a custom entity

## Create a query implementation class

## Add the custom entity to your service definition

## Add the custom entity as a value help

## Test the service 

## Summary

You've now ...

Continue to - [Exercise 3 - Excercise 3 ](../ex3/README.md)
