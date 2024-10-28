import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Time "mo:base/Time";

actor {
  type InvoiceId = Nat;
  
  type Service = {
    description : Text;
    amount : Nat;
  };

  type Invoice = {
    id : InvoiceId;
    client : Text;
    services : [Service];
    totalAmount : Nat;
    date : Time.Time;
  };

  var invoices = Buffer.Buffer<Invoice>(0);

  public func createInvoice(client : Text, services : [Service]) : async InvoiceId {
    let invoiceId = invoices.size();
    var total = 0;
    for (service in services.vals()) {
      total += service.amount;
    };
    
    let newInvoice : Invoice = {
      id = invoiceId;
      client = client;
      services = services;
      totalAmount = total;
      date = Time.now();
    };
    invoices.add(newInvoice);
    invoiceId;
  };

  public query func getInvoice(invoiceId : InvoiceId) : async ?Invoice {
    if (invoiceId < invoices.size()) {
      ?invoices.get(invoiceId);
    } else {
      null;
    };
  };

  public query func getAllInvoices() : async [Invoice] {
    Buffer.toArray(invoices);
  };

  public query func getInvoicesByClient(client : Text) : async [Invoice] {
    let results = Buffer.Buffer<Invoice>(0);
    for (invoice in invoices.vals()) {
      if (Text.equal(invoice.client, client)) {
        results.add(invoice);
      };
    };
    Buffer.toArray(results);
  };
};
