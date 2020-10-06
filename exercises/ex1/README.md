# Exercise 1

In this exercise, we will create a starter application to collect inventory data. Since we want to concentrate on developing an extension scenario we will try to speed up the process to built the basic inventory application.
 
For this we will use the RAP Generator.


## Connect to the system

1. Start the ABAP Development Tools (aka ABAP in Eclipse)

2. Select a directory as workspace. Click **Launch**

 ![Select directory](images/0010.png)

3. Close the Welcome screen

 ![Close Welcome screen](images/0020.png)

4. Check Perspective. If the perspective is still the Java perspective

 ![Java perspective](images/0030.png)

5. Open ABAP perspective (if needed)

  - Click on the **Open perspective** button
  - Select **ABAP**
  - Click **Open**

 ![OpenABAP perspective](images/0040.png)

5. Click **File > New > ABAP Cloud Project** to open a new ABAP Cloud project.

 ![OpenABAP perspective](images/0050.png)

5. Choose the option **SAP Cloud Platform Cloud Foundry Environment** and then click **Next** .

 ![System connection options](images/0060.png)

> Here you have to two options how to connect to your SAP Cloud Platform ABAP environment system. We suggest to logon to the SAP Cloud Platform Cloud Foundry Environment and navigate to your ABAP instance. The other option would be to connect directly to the ABAP environment. For this you would have to provide the service key that you have downloaded when setting up your ABAP instance. 

6. Provide the SAP Cloud Foundry connection settings. In this dialogue select the following values

  - Region: Select the region e.g. **Europe (Frankfurt)** or **US East (VA)**.
  - Username: Enter **<your email adress>**
  - Password: Enter **<your password>** you use to log on to SAP Cloud platform
 
  ![CF connection options](images/0070.png)

  Click **Next**.

> The API endpoint will be selected according to the region you have chosen.
   
7. Select service instance details

 - Organization: Select your organization e.g. **xxxxxxtrial**
 - Space: Select the space in your CF sub account e.g. **dev**
 - Service instance: Click on the name of your ABAP trial instance e.g. **default_abap-trial**.
 
 Click **Next**.

![CF connection settings](images/0080.png)

8. Check service connection settings and press **Next**.

![Service instance connection](images/0090.png)

8. You can keep the default project name, e.g. **TRL_EN** unchanged and click **Finish**

![Project name](images/0100.png)


## Create a package

1. Richt-click on **`ZLOCAL`** and from the context menu choose **New > ABAP Package**.

![New package_1](images/0200.png)

2. In the Create new ABAP package dialogue enter the following values

   - Name: Enter **`ZRAP_INVENTORY_####`** in the field Name.
   - Description: Enter a meaningful description for your package, e.g. **Inventory demo ####**. 

![New package_2](images/0210.png)

3. Select or create a new transport request and click **Finish**.

![New transport request](images/0220.png)

6. Add your package to your **Favorites Packages** folder.

  - Right click on the folder **Favorites Packages**

![New transport request](images/0105.png)

  - and start to type **`ZRAP`**
  - choose your package **`ZRAP_INVENTORY_####`** from the list of machting items
  - Press **Ok**

![New transport request](images/0110.png)

5. Result

You have created a package in the super package ZLOCAL. The package ZLOCAL has a similar role as the package $TMP has in on premise systems.

You can see now an entry in the **Transport Organizer** view
 
> **Caution:**
> If you start developing in a non-trial system you should use sub-packages in ZLOCAL **ONLY** for tests but **NOT** for real development.
> For real development you have to create your own software components and own development packages.


![New transport request](images/0230.png)


## Create a table

Now after you have created a package we can start developing an application. We will start with the development of a table that will be used to store inventory data. Since this is a green field scenario the application will be implemented using a **managed business object** that is based on the **ABAP RESTful Application Programming Model (RAP)**.
 
This application will then be enhanced such that it leverages OData service calls and SOAP calls to retrieve data from a SAP S/4HANA backend. These services are either called as a value help or to perform a determination for the price of a product whenthe inventory data is created or updated.

1. Right click on your package. Click **New > Other ABAP Repository Object**.

![New Database Table](images/0270.png)

2. Click **Database Table > Next**.

![New Database Table](images/0280.png)

3. In the Createa a database table dialgue enter the following values:

   - Name: Enter **`zrap_inven_####`** .
   - Description: Enter **`Inventory data`**.
   
   Press **Next**.
   
   ![New Database Table](images/0290.png)
   
4. Select a transport request and click **Finish**.

![Select transport request](images/0300.png)

6. Check the code template.

![Code template Inventory Table](images/0310.png)

6. Copy and paste the following coding .

<pre>
@EndUserText.label : 'Inventory data'
@AbapCatalog.enhancementCategory : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zrap_inven_#### {
  key client      : abap.clnt not null;
  key uuid        : sysuuid_x16 not null;
  inventory_id    : abap.numc(6) not null;
  product_id      : abap.char(10);
  @Semantics.quantity.unitOfMeasure : 'zrap_inven_####.quantity_unit'
  quantity        : abap.quan(13,3);
  quantity_unit   : abap.unit(3);
  remark          : abap.char(256);
  not_available   : abap_boolean;
  created_by      : syuname;
  created_at      : timestampl;
  last_changed_by : syuname;
  last_changed_at : timestampl;
}
</pre>

7. and replace the placeholder **`####`** with your group number.

![Inventory Table](images/0320.png)

8. Click here to activate your changes.

The table that will be used by our inventory application has the following structure.

The key field **`uuid`** is a *Universally Unique Identifier (UUID)*. 

This mandatory for a managed scenario where early numbering is used. That means where the ABAP framework automatically generates values for the key field when creating the data.
 
The last four fields
 
**`created_by`**   
**`created_at`**
**`last_changed_by`**
**`last_changed_at`**
 
are also mandatory in a managed scenario. The framework expects these type of fields so that it is able to check when data has been created and changed.
 
The usual process of development would be that you as a developer would now start to manually create the following repository objects
 
·	CDS interface view
·	CDS projection view
·	Metadata Extension view
·	Behavior definition(s)
·	Behavior implementation(s)
 
before you can start with the implementation of the business logic.
 
To speed up the process we will use the RAP Generator that will generate a starter project for us containing all these objects. This way you can concentrate on developing the business logic of this extension scenario without the need to type lots of boilerplate coding beforehand.

## Generate a starter application

1. Create a JSON file **`inventory.json`** with the following content locally on your desktop. 

<pre>
{
  "implementationType": "managed_uuid",
  "namespace": "Z",
  "suffix": "_1234",
  "prefix": "RAP_",
  "package": "ZRAP_INVENTORY_1234",
  "datasourcetype": "table",
  "hierarchy": {
    "entityName": "Inventory",
    "dataSource": "zrap_inven_1234",
    "objectId": "inventory_id"    
    }
}
</pre>

1. Add the package ZRAP_GENERATOR to your favorites packages
   - Click on **Favorite Packages** with the right mouse button.
   - Click **Add Package ...**  

![Add package to Favorites_1](images/0350.png)

2. Start to type ZRAP_GENERATOR and double-click on it. 

![Add package to Favorites_2](images/0360.png)

3. Expand the folders **Connectivity > HTTP Services** and double-click on **Z_RAP_GENERATOR**.

![Open RAP Generator](images/0370.png)

4. Click on **URL**

![Open UI of the RAP Generator](images/0380.png)

5. Enter your credentials

![Authenticate at ABAP Environment](images/0390.png)

6. Start the generation of the RAP business object.
   - Browse for your JSON File **Inventory.json** and then
   - Press the button **Upload File and generate BO**

![Start generation](images/0400.png)

7. Wait a short time

![Start generation](images/0410.png)

8. Success message

![RAP BO generated](images/0420.png)

9. When you check the content of your package you will notice that it now contains 12 repository objects.

![RAP BO generated](images/0430.png)

10. The RAP Genertor has generated the following repository objects for your convenience

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
 

> What is now left is to publish the service binding since this cannot be automated (yet).


11. Open the service binding and double click on **´ZUI_RAP_INVENTORY_####_02´**

![Open Service Binding](images/0435.png)

12. Click on **Activate** to activate the Service Binding. 

![Activate Service Binding](images/0440.png)

13. Select the entity **Inventory** and press the **Preview** button to start the *Fiori Elements Preview*.

![Start Fiori Elements Preview](images/0440.png)

14. Check the Fiori Elements Preview App. You will notice that we got a nearly full fledged UI with capabilities for 

   - Searching
   - Filtering
   - Create, Update and Delete inventory data
   
  ![Fiori Elements Preview](images/0470.png)

## Check the generated repository objects

The interface view was generated such that based on the ABAP field names aliases have been created such that the ABAP field name was converted into camelCase notation.

<pre>
define ROOT view ZJRP_I_INVENTORY_JRP4
  as select from ZRAP_INVEN_JRP3
{
  key UUID as Uuid,
  
  INVENTORY_ID as InventoryId,
  
  PRODUCT_ID as ProductId,
</pre>

The behavior impelemenation was generated such that the semantic key was marked as readonly.

<pre>
field ( readonly ) InventoryId;
</pre>

also a mapping was added that maps the ABAP field names to the field names of the CDS views.

<pre>
mapping for ZRAP_INVEN_JRP3
{
Uuid = UUID;
InventoryId = INVENTORY_ID;
ProductId = PRODUCT_ID;
</pre>

And we find a determination that was generated for the semantic key field (that has to be implemented though).

<pre>
determination CalculateSemanticKey on modify
{ create; }
</pre> 
 
The behavior implementation contains already the definition of the method that needs to be implemented to calculate the semantic key.

<pre>
CLASS LHC_INVENTORY DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      CALCULATE_SEMANTIC_KEY FOR DETERMINATION Inventory~CalculateSemanticKey
        IMPORTING
          IT_KEYS FOR Inventory.
ENDCLASS.
CLASS LHC_INVENTORY IMPLEMENTATION.
  METHOD CALCULATE_SEMANTIC_KEY.
  " Determination implementation goes here
  ENDMETHOD.
ENDCLASS.
<pre>

Last not least you will find it handy that also a Metdata Extension View has been generated that automatically publishes all field on the list page as well as on the object page by setting appropriate @UI annotations. Also the administrative fields such as the UUID based key and fields like created_at are hidden by setting @UI.hidden to true.
 
 <pre>
  @UI.hidden: true
  CreatedAt;
  
  @UI.hidden: true
  CreatedBy;
  
  @UI.lineItem: [ {
    position: 20 , 
    importance: #HIGH, 
    label: 'InventoryId'
  } ]
  @UI.identification: [ {
    position: 20 , 
    label: 'InventoryId'
  } ]
  InventoryId;
</pre> 
Feel free to check out more of the generated code.



## Summary
You've now ...

Continue to - [Exercise 2 - Exercise 2 Description](../ex2/README.md)

