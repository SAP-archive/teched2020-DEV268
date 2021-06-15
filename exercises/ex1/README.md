
[Home](../../README.md#exercises)

# Exercise 1

 
- [Generate the data model](#generate-the-data-model)
- [Publish service](#publish-service)
- [Check the generated repository objects](#check-the-generated-repository-objects)
- [Behavior Implementation](#behavior-implementation)
- [Summary](#summary)
- [Solution](sources)

In this exercise, we will create a starter application to collect inventory data. 

The usual process of development would be that you as a developer would now start to manually create the following repository objects for each entity
 
-	Table
- CDS interface view
-	CDS projection view
-	Metadata Extension view
-	Behavior definition
-	Behavior implementation
 
before you can start with the implementation of the business logic.
 
In the ABAP trial systems we have thus prepared a helper class **/dmo/cl_gen_dev268_artifacts** to generate the database table to store the inventory data and different CDS artefacts needed for the next exercises.  

Since this is a green field scenario the application will be implemented using a **managed business object** that is based on the **ABAP RESTful Application Programming Model (RAP)**.
 
This application will then be enhanced such that it leverages OData service calls and SOAP calls to retrieve data from a SAP S/4HANA backend. These services are either called as a value help or to perform a determination for the price of a product whenthe inventory data is created or updated.

## Generate the data model
  
1. Select the **Open ABAP Development Object** icon or press **Ctrl+Shift+A**. 

   ![Open ABAP Development Object](images/00_001_DEV268.png)

2. In the *Open ABAP Development Object* dialogue enter **/dmo/cl_gen_dev268_artifacts** as search string and press **OK**.      

   ![Generate Data Model](images/00_002_DEV268.png)

2. The class **/dmo/cl_gen_dev268_artifacts** is displayed in a new tab.

    ![Generate Data Model](images/00_003_DEV268.png)
  
3. Press **F9** to run the ABAP class as a console application. As a result, you will see a success message in the Console.     

    ![Generate Data Model](images/00_004_DEV268.png)  

4. Please note down your group ID **`####`** and copy the name of the newly created package **ZRAP_INVENTORY_####**
    <pre>
     BEGIN OF GENERATION (20210614 081539 UTC) ... 
     - Package: ZRAP_INVENTORY_#### 
     - Group ID: ####
     </pre>
   
5. Right click on the folder **Favorite Packages** and select **Add Package...**.

   ![Open ABAP Development Object](images/00_005_DEV268.png)

6. Enter the name of your package **ZRAP_INVENTORY_####** and press **OK**.    
 
 
## Publish service

1. The helper class **/dmo/cl_gen_dev268_artifacts** has done the following:
 
    - Using the XCO framework it has created a table to store the inventory data  
    - It then has called the RAP Genertor which has generated the following repository objects for your convenience based on the table that has been generated beforehand

    Business Services
    - ZUI_RAP_INVENTORY_####_02 - Service Binding
    - ZUI_RAP_INVENTORY_#### - Service Definition

    CDS views
    - ZC_RAP_INVENTORY_#### - Projection view
    - ZI_RAP_INVENTORY_#### - Interface view

    Metadata Extension
    - ZC_RAP_INVENTORY_#### - MDE for the projection view

    Behavior Defintion
    - ZC_RAP_INVENTORY_#### - for the projection view
    - ZI_RAP_INVENTORY_#### - for the interface view
 

> What is now left is to publish the service binding since this can not be automated (yet).


2. Open the service binding and double click on **ZUI_RAP_INVENTORY_####_O2**  
    (in older versions of the RAP Generator it reads _02 instead of _O2)

    ![Open Service Binding](images/0435.png)

3. Click on **Publish** to publish the Service Binding. 

    ![Publish Service Binding](images/0440.png)

4. Select the entity **Inventory** and press the **Preview** button to start the *Fiori Elements Preview*.

    (The service also contains an entity I_Currency since the RAP Generator has added a value help for Currencies to the projection view.) 

   ![Start Fiori Elements Preview](images/0460.png)

5. Check the Fiori Elements Preview App. You will notice that we got a nearly full fledged UI with capabilities for 

    - Searching
    - Filtering
    - Create and Delete inventory data
    - Update, visible when having created data
   
This is because all possible behaviors (create, update and delete) have been enabled by default in our generated code.
You will see that all CRUD operations are working out of the box (apart from calculating the inventory id, which we will do in a second).
In addition all columns of the table are displayed by default as well since we have generated appropriate UI annoations. 
If you do not want to see all columns (either on the list- or the object page) you can comment out these annotations.
This is however much simpler than having to write all these annotations from scratch.

16. You can try and start entering values for your first inventory item.
However no checks nor any value help have been implemented yet. 
Especially not for the determination of the semantic key **InventoryId**.

This we will do in the next step.

   
  ![Fiori Elements Preview](images/0470.png)

## Check the generated repository objects

The **interface view ZI_RAP_Inventory_####** was generated such that based on the ABAP field names aliases have been created such that the ABAP field name was converted into camelCase notation.

<pre>
define root view entity ZI_RAP_INVENTORY_1234
  as select from zrap_inven_1234
{
  key UUID as UUID,  
  INVENTORY_ID as InventoryID,  
  PRODUCT_ID as ProductID,  
  @Semantics.quantity.unitOfMeasure: 'QuantityUnit'
  QUANTITY as Quantity,  
  QUANTITY_UNIT as QuantityUnit,
  ...
 }
</pre>

The **projection view ZC_RAP_Inventory_####** was generated such that it contains annotations for **search** and a value help for the field **CurrencyCode**.

<pre>
define root view entity ZC_RAP_INVENTORY_####
  as projection on ZI_RAP_Inventory_####
{
  @Search.defaultSearchElement: true
  key UUID,
  
  @Search.defaultSearchElement: true
  InventoryID,
  
  ProductID,
  
  Quantity,
  
  QuantityUnit,
  
  @Semantics.amount.currencyCode: 'CurrencyCode'
  Price,
  
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: 'I_Currency', 
      element: 'Currency'
    }
  } ]
  CurrencyCode,
</pre>

The **behavior definion ZI_RAP_Inventory_####** was generated such that the field **InventoryID** which acts as a semantic key was marked as readonly.

<pre>
field ( readonly ) InventoryID;
</pre>

also a mapping was added that maps the ABAP field names to the field names of the CDS views.

<pre>
  mapping for zrap_inven_1234
  {
    UUID = UUID;
    InventoryID = INVENTORY_ID;
    ProductID = PRODUCT_ID;
    Quantity = QUANTITY;
    QuantityUnit = QUANTITY_UNIT;
    Remark = REMARK;
    NotAvailable = NOT_AVAILABLE;
    CreatedBy = CREATED_BY;
    CreatedAt = CREATED_AT;
    LastChangedBy = LAST_CHANGED_BY;
    LastChangedAt = LAST_CHANGED_AT;
  }
</pre>

And we find a determination that was generated for the semantic key field (that has to be implemented though).

Please make sure that the determination that is performed during the **'save*** sequence for the InventoryID is triggered by **'create'** operation.
*(in older versions the RAP Generator created a determination that acts on the modify operation)*  

<pre>
determination CalculateInventoryID on save { create; }
</pre> 
 
## Change the generated code of the Metadata Extension File

Last but not least, you will find it handy that a **Metadata Extension View ZC_RAP_Inventory_####** has also been generated that automatically publishes all field on the list page as well as on the object page by setting appropriate **@UI** annotations. 

Also the administrative fields like created_at as well as the UUID based key field are hidden by setting **@UI.hidden** to true.

In the version of the RAP Generator which is currently deployed to SAP BTP ABAP evnironment trial ualso the fields **CurrencyCode** and **QuantityUnit** have been marked as **@UI.hidden**.  

Please change the code such that you remove the annotation **@UI.hidden** for QuantityUnit and CurrencyCode so that the code now reads:

- QuantityUnit 

  <pre>
  @UI.lineItem: [ {
  position: 50 ,
  importance: #HIGH,
  label: 'Price'
  } ]
  @UI.identification: [ {
    position: 50 ,
    label: 'Price'
  } ]
  QuantityUnit;  
  </pre> 

- CurrencyCode

  <pre>
  @UI.lineItem: [ {
  position: 70 ,
  importance: #HIGH,
  label: 'Price'
  } ]
  @UI.identification: [ {
    position: 70 ,
    label: 'Price'
  } ] 
  CurrencyCode;
  </pre>

Feel free to check out more of the generated code.

## Behavior Implementation

1. In the **Project Explorer** navigate to **Core Data Services > Behavior Definitions** and double click on  **ZI_RAP_INVENTORY_####**

 ![Open Behavior Definition](images/0500.png)

2. In the source code you will see the warning 

   *Class "ZBP_I_RAP_INVENTORY_1234" does not exist.* 
   
   - Click on the name of the behavior implementation class **`ZBP_I_RAP_Inventory_####`**
   - Press **Ctrl+1** to open the *quick fix / quick assist* dialog
  
The quick fix offers you to create a global behavior implementation class **`zbp_i_rap_inventory_####`** for the behavior definition **`zi_rap_inventory_####`**.
  
   ![Quick Fix Behavior Implemenation](images/0510.png)
  
   - Double click on **`Create behavior implementation class zbp_i_rap_inventory_####`**
  

  
  4. The **New Behavior Definition** dialogue opens
    - Leave the default settings and press **Next**

     ![Open behavior defintion class](images/0520.png)

  5. Select a transport request and press **Finish**
  
     ![Select Transport request](images/0530.png)
  
  6. Implement the determination for the field **InventoryID**
  
The code of the behavior implementation contains already an (empty) implementation for the determiniation that shall calculate the semantic key InventoryID. 

The implementation of the behavior defintion must (for technical reasons) take place in local classes that follow the naming convention **lhc_\<EntityName\>** (here **lhc_Inventory**).
We suggest to use the source code shown below to implement the calculation of the semantic key of our managed business object for inventory data. In a productive application you would rather use a number range.
To keep our implementation simple we will use the approach to simply count the number of objects that are available. 
By a simple increment of this number we get a semantic key which is readable by the users of our application.



 <pre> 
 
METHOD CalculateInventoryID.

  "Ensure idempotence
    READ ENTITIES OF zi_rap_inventory_#### IN LOCAL MODE
      ENTITY Inventory
        FIELDS ( InventoryID )
        WITH CORRESPONDING #( keys )
      RESULT DATA(inventories).

    DELETE inventories WHERE InventoryID IS NOT INITIAL.
    CHECK inventories IS NOT INITIAL.

    "Get max travelID
    SELECT SINGLE FROM zrap_inven_#### FIELDS MAX( inventory_id ) INTO @DATA(max_inventory).

    "update involved instances
    MODIFY ENTITIES OF zi_rap_inventory_#### IN LOCAL MODE
      ENTITY Inventory
        UPDATE FIELDS ( InventoryID )
        WITH VALUE #( FOR inventory IN inventories INDEX INTO i (
                           %tky      = inventory-%tky
                           inventoryID  = max_inventory + i ) )
    REPORTED DATA(lt_reported).

    "fill reported
    reported = CORRESPONDING #( DEEP lt_reported ).

ENDMETHOD.
 
</pre>
   
 7. Replace the placeholders <b>####</b> with your group number and activate your changes **(Ctrl+F3)**

 ![Replace the placeholders](images/0540.png)

8. Test the implementation. 

  - Start the Fiori Elements preview and press the **Create** button.
  - Enter an arbritray product name
  - Press **Save**
  
   ![Open behavior defintion class](images/0550.png)
  
9. Check the numbering for your semantic key

 
   ![Open behavior defintion class](images/0570.png)



## Summary

You have completed the exercise!
 
You are now able to:
-	Implement Behavior Definitions to enable create, update and delete operations and make fields read-only	Implement Behavior Implementations so that ABAP code in determinations is run when an object is created.
-	Use the Fiori Elements preview to test your service


Continue with - [Exercise 2](../ex2/README.md)

