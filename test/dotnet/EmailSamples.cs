using System.Collections.Generic;
using Newtonsoft.Json;

namespace Salaros.Email.Test
{
    internal class EmailSamples
    {
        /// <summary>
        /// Gets or sets the business.
        /// </summary>
        /// <value>
        /// The business.
        /// </value>
        [JsonProperty("business")]
        public List<string> BusinessEmails { get; internal set; }

        /// <summary>
        /// Gets or sets the free.
        /// </summary>
        /// <value>
        /// The free.
        /// </value>
        [JsonProperty("free")]
        public List<string> FreeEmails { get; internal set; }
    }
}
