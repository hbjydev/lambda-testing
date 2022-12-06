import { ConductorSQS } from './resources/sqs';

import './resources/lambda';
import './resources/lambda2';
import './resources/lambda3';

// Create an AWS resource (S3 Bucket)
export const queue = new ConductorSQS({
  name: 'conductor-queue',
});

queue.queue.onEvent(
  "testRcv",
  (event) => {
    event.Records.forEach(v => {
      let json = JSON.parse(v.body);
    });
  },
);

