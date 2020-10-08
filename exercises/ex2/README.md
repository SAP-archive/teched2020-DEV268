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

## Create a console application to test the OData service



## Create a custom entity

## Create a query implementation class

## Add the custom entity to your service definition

## Add the custom entity as a value help

## Test the service 

## Summary

You've now ...

Continue to - [Exercise 3 - Excercise 3 ](../ex3/README.md)
