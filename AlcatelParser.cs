using System;
using System.Xml;
using System.Web;
using System.Security.Cryptography.X509Certificates;
using System.Net;
using System.Net.Security;
using System.IO;
using System.Collections.Generic;
namespace AlcatelParser {
	
    public class Interface {
		public string Name;
		public string IpAddress;
        public int Vlan;
        public int IfIndex;
    }
	
    public class Switch {
		public string SystemName;
        public string RouterId;
		public List<Vlan> Vlans;
        public List<Interface> Interfaces;
    }
	
    public class Vlan {
		public int Id;
		public string Name;
		public string State;
        public List<string> UntaggedMembers;
        public List<string> TaggedMembers;
    }
}
