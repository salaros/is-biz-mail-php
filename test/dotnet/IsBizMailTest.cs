using System.IO;
using Xunit;
using System.Reflection;

namespace Salaros.Email.Test
{
    public class IsBizMailTest
    {
        [Fact]
        public void IsValid()
        {
            foreach (var businessEmail in EmailSamples.BusinessEmails)
            {
                var isValid = IsBizMail.IsValid(businessEmail);
                Assert.True(isValid, $"{businessEmail} is not free (business)");
            }

        }

        [Fact]
        public void IsFree()
        {
            foreach (var freeEmail in EmailSamples.FreeEmails)
            {
                var isFree = IsBizMail.IsFreeMailAddress(freeEmail);
                Assert.True(isFree, $"{freeEmail} is free");
            }

        }

        [Fact]
        public void HasDomainDefinitions()
        {
            Assert.NotEmpty(IsBizMail.GetFreeDomains());
        }

        private static readonly EmailSamples EmailSamples;

        static IsBizMailTest()
        {
            var sampleEmailsPath = Directory.GetParent(Assembly.GetExecutingAssembly().Location).FullName;
            sampleEmailsPath = Path.Combine(sampleEmailsPath, "emailSamples.json");
            var sampleEmailsRaw = File.ReadAllText(sampleEmailsPath);
            EmailSamples = Newtonsoft.Json.JsonConvert.DeserializeObject<EmailSamples>(sampleEmailsRaw);
        }
    }
}
