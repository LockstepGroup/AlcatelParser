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
		public int Id;
		public string Name;
		public string State;
        public List<string> UntaggedMembers;
        public List<string> TaggedMembers;
    }
}
