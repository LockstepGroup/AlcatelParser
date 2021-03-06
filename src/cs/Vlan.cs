using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Xml;
using System.Web;

namespace AlcatelParser {
	
    public class Vlan {
		public int Id;
		public string Name;
		public string State;
        public List<string> UntaggedMembers;
        public List<string> TaggedMembers;
    }
}