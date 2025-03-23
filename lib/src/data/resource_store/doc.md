# Resource store

This store is for save all the resources founded at the moment of the user if update some part.

## How are resources saved?

While the user is typing or inserting elements into a document, the algorithm ensure that we want to check first, if the doc is valid to be part of the resources of the project. When you let a document empty, and after insert an image, this will be taked in account by the `ResourceStore` and saved.

## How are resources removed?

The store has a saved document, and, we go to that one, and remove or insert another contents, the store will listen that changes, and will remove it to avoid add a not valid resource.

> [!NOTE]
> All these steps are maded after complete the default delay for take changes in account (like 1000 milliseconds).

## The Resource store listen the changes of the project 

Partially yes. But, it only listen the changes of the documents into the project. The store saves the document id. If that id is removed or updated into the ProjectState then that last one will call to the store and notifies that need to remove it or update it's value.
