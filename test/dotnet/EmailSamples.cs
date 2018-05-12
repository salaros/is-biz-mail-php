using System.Collections.Generic;
using Newtonsoft.Json;

namespace Salaros.Email.Test
{
    class EmailSamples
    {
        [JsonProperty("business")]
        public List<string> Business { get; set; }

        [JsonProperty("free")]
        public List<string> Free { get; set; }
    }
}
