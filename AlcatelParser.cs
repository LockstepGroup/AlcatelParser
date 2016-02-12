using System;
using System.Xml;
using System.Web;
using System.Security.Cryptography.X509Certificates;
using System.Net;
using System.Net.Security;
using System.IO;
using System.Collections.Generic;
namespace AlcatelParser {
	
    public class Vlan {
		public string Id;
		public string Name;
		public string State;
        public string UntaggedMembers;
        public string TaggedMembers;
    }
}
