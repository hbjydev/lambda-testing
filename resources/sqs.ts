import { ComponentResource, CustomResourceOptions } from '@pulumi/pulumi';
import { sqs } from '@pulumi/aws';

type ConductorSQSArgs = {
  name: string;
};

export class ConductorSQS extends ComponentResource {
  public queue: sqs.Queue;

  constructor(args: ConductorSQSArgs, opts?: CustomResourceOptions) {
    const resourceName = `kur-${args.name}`;

    super("pkg:index:ConductorSQS", resourceName, opts);

    const sqsArgs: sqs.QueueArgs = {
      name: resourceName,
      visibilityTimeoutSeconds: 180,
    };

    this.queue = new sqs.Queue(
      resourceName,
      sqsArgs,
      {
        parent: this,
      }
    );
  }
}
