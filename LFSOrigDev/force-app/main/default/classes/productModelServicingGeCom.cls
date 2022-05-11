//Generated by wsdl2apex

public class productModelServicingGeCom {
    public class ProductHierarchyCom {
        public String label;
        public productModelServicingGeCom.ProductHierarchyCollection productHierarchyCollection;
        public productModelServicingGeCom.ProductCollection productCollection;
        private String[] label_type_info = new String[]{'label','http://product.model.servicing.ge.com',null,'0','1','false'};
        private String[] productHierarchyCollection_type_info = new String[]{'productHierarchyCollection','http://product.model.servicing.ge.com',null,'0','1','false'};
        private String[] productCollection_type_info = new String[]{'productCollection','http://product.model.servicing.ge.com',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://product.model.servicing.ge.com','false','false'};
        private String[] field_order_type_info = new String[]{'label','productHierarchyCollection','productCollection'};
    }
    public class Product {
        public String id;
        public String type_x;
        public String SOLCode;
        public String name;
        public String description;
        public commonModelServicingGeCom.Variable[] attribute;
        public commonModelServicingGeCom.CodeName[] relationship;
        public String[] group_x;
        public String category;
        private String[] id_type_info = new String[]{'id','http://product.model.servicing.ge.com',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','http://product.model.servicing.ge.com',null,'0','1','false'};
        private String[] SOLCode_type_info = new String[]{'SOLCode','http://product.model.servicing.ge.com',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','http://product.model.servicing.ge.com',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','http://product.model.servicing.ge.com',null,'0','1','false'};
        private String[] attribute_type_info = new String[]{'attribute','http://product.model.servicing.ge.com',null,'0','-1','false'};
        private String[] relationship_type_info = new String[]{'relationship','http://product.model.servicing.ge.com',null,'0','-1','false'};
        private String[] group_x_type_info = new String[]{'group','http://product.model.servicing.ge.com',null,'0','-1','false'};
        private String[] category_type_info = new String[]{'category','http://product.model.servicing.ge.com',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://product.model.servicing.ge.com','false','false'};
        private String[] field_order_type_info = new String[]{'id','type_x','SOLCode','name','description','attribute','relationship','group_x','category'};
    }
    public class ProductHierarchyCollection {
        public productModelServicingGeCom.ProductHierarchyCom[] productNode;
        private String[] productNode_type_info = new String[]{'productNode','http://product.model.servicing.ge.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://product.model.servicing.ge.com','false','false'};
        private String[] field_order_type_info = new String[]{'productNode'};
    }
    public class productHierarchy_element {
        public productModelServicingGeCom.ProductHierarchyCom[] productNode;
        private String[] productNode_type_info = new String[]{'productNode','http://product.model.servicing.ge.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://product.model.servicing.ge.com','false','false'};
        private String[] field_order_type_info = new String[]{'productNode'};
    }
    public class productInventory_element {
        public productModelServicingGeCom.Product[] product;
        private String[] product_type_info = new String[]{'product','http://product.model.servicing.ge.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://product.model.servicing.ge.com','false','false'};
        private String[] field_order_type_info = new String[]{'product'};
    }
    public class ProductCollection {
        public productModelServicingGeCom.Product[] product;
        private String[] product_type_info = new String[]{'product','http://product.model.servicing.ge.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://product.model.servicing.ge.com','false','false'};
        private String[] field_order_type_info = new String[]{'product'};
    }
}