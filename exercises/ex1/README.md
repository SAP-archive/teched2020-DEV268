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

2. Click **Database Table > Next**.

3. In the Createa a database table dialgue enter the following values:

   - Name: Enter **`zrap_inven_####`** .
   - Description: Enter **`Inventory data`**.


6. Click  Next.




## Generate a starter application

## Summary
You've now ...

Continue to - [Exercise 2 - Exercise 2 Description](../ex2/README.md)

