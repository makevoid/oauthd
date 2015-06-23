var me = {
    fetch: [

        function(fetched_elts) {
            return '/api/myself';
        }

    ],
    params: {},
    fields: {
        username: function (data) {
            return data.username;
        },
        url: function (data) {
            return data.url;
        }
    }
};
module.exports = me;
